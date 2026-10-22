import { test, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { chromium } from 'playwright';
import { spawn } from 'node:child_process';
import { once } from 'node:events';
import { readFile, mkdir, access } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const origin='http://127.0.0.1:4183';
let browser, server;
const data=JSON.parse(await readFile(path.join(root,'content/site.json'),'utf8'));
before(async()=>{
  server=spawn(process.execPath,['scripts/serve.mjs'],{cwd:root,env:{...process.env,PORT:'4183'},stdio:['ignore','pipe','pipe']});
  await Promise.race([once(server.stdout,'data'),once(server,'exit').then(()=>{throw new Error('Preview server failed');})]);
  let executablePath=process.env.BROWSER_PATH;
  if (!executablePath && process.platform==='win32') {
    const chrome='C:/Program Files/Google/Chrome/Application/chrome.exe';
    try {await access(chrome);executablePath=chrome;} catch {}
  }
  browser=await chromium.launch({executablePath,headless:true});
  await mkdir(path.join(root,'test-results'),{recursive:true});
});
after(async()=>{await browser?.close();server?.kill();});

async function page(options={}) {
  const context=await browser.newContext({viewport:{width:1440,height:900},...options});
  const page=await context.newPage();
  // Contact tests must never submit real messages.
  await page.route('https://formsubmit.co/**',route=>route.abort());
  return page;
}
async function loaded(p,url='/') {await p.goto(origin+url);await p.evaluate(()=>document.fonts.ready);}
async function noOverflow(p) {assert.ok(await p.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),`Page must not overflow horizontally: ${p.url()} at ${p.viewportSize().width}px`);}

test('home preserves content, assets, tools, and contact anchor',async()=>{
  const p=await page({reducedMotion:'reduce'});
  const errors=[];p.on('pageerror',e=>errors.push(e.message));
  await loaded(p);
  assert.equal(await p.locator('h1').textContent(),'I am Nilakna,');
  assert.equal(await p.locator('.tools li').count(),16);
  assert.equal(await p.locator('.profile-card').count(),7);
  assert.equal(await p.locator('.publication').count(),2);
  for (const image of await p.locator('img').all()) {await image.scrollIntoViewIfNeeded();await image.evaluate(img=>img.decode());}
  assert.equal(await p.locator('.profile-card').first().locator('p').textContent(),data.profiles[0].description.replace(/\n/g,''));
  await p.getByRole('link',{name:'Contact',exact:true}).click();
  assert.equal(new URL(p.url()).hash,'#contact');
  assert.equal(errors.length,0);
  await noOverflow(p);
  await p.evaluate(()=>scrollTo(0,0));
  await p.screenshot({path:path.join(root,'test-results/home-desktop.png')});
  await p.context().close();
});

test('all 16 project readers load, with local images, tables, and equations',async()=>{
  const p=await page();
  await loaded(p,'/projects/');
  assert.equal(await p.locator('.project-tile').count(),16);
  assert.equal(await p.locator('.award-card').count(),8);
  for (const project of data.sections.flatMap(s=>s.items)) {
    await p.locator(`.project-tile[data-project="${project.markdownAssetPath}"]`).click();
    await p.locator('[data-reader-content]').waitFor();
    assert.ok((await p.title()).startsWith(project.title));
    assert.equal(new URL(p.url()).searchParams.get('project'),project.markdownAssetPath);
    for (const image of await p.locator('.markdown img').all()) {
      assert.ok((await image.getAttribute('src')).startsWith('assets/'));
      await image.scrollIntoViewIfNeeded();await image.evaluate(img=>img.decode());
    }
    if (project.markdownAssetPath.includes('ctsignals')) {
      assert.ok(await p.locator('.katex').count()>20);
      assert.ok(await p.locator('.markdown table').count()>0);
      assert.equal(await p.locator('.katex-error').count(),0);
    }
    await p.getByRole('link',{name:'All projects',exact:true}).click();
    await p.locator('#projects-grid').waitFor({state:'visible'});
  }
  await p.evaluate(()=>scrollTo({top:0,behavior:'instant'}));
  await p.screenshot({path:path.join(root,'test-results/projects-desktop.png')});
  await p.context().close();
});

test('query URLs, refresh, back/forward, unknown projects, and legacy redirects',async()=>{
  const p=await page();
  await loaded(p,'/projects?project=assets%2Fmarkdown%2Fopamp.md');
  await p.locator('[data-reader-content]').waitFor();
  await p.reload();await p.locator('[data-reader-content]').waitFor();
  await p.getByRole('link',{name:'All projects',exact:true}).click();
  await p.goBack();await p.locator('[data-reader-content]').waitFor();
  await p.goForward();await p.locator('#projects-grid').waitFor({state:'visible'});
  await loaded(p,'/projects/?project=missing');
  assert.equal(await p.locator('.project-tile').count(),16);
  await p.goto(origin+'/blog/');await p.waitForURL('**/projects/');
  await p.goto(origin+'/about/');await p.waitForURL(origin+'/');
  await p.goto(origin+'/publications/');await p.waitForURL(origin+'/');
  await p.context().close();
});

test('reader failures offer retry and recover',async()=>{
  const p=await page();
  await p.route('**/projects/opamp/',route=>route.fulfill({status:503,body:'Unavailable'}));
  await loaded(p,'/projects/?project=assets%2Fmarkdown%2Fopamp.md');
  await p.getByRole('button',{name:'Try again'}).waitFor();
  await p.unroute('**/projects/opamp/');
  await p.getByRole('button',{name:'Try again'}).click();
  await p.locator('[data-reader-content]').waitFor();
  await p.context().close();
});

test('resource search and consent/password reset match Flutter',async()=>{
  const p=await page();await loaded(p,'/resources/');
  const show=p.getByRole('button',{name:'Agree and Show Password'});
  assert.ok(await show.isDisabled());
  await p.locator('#resource-agreement').check();await show.click();
  assert.equal(await p.locator('#resource-password').textContent(),'student-resources');
  assert.ok(await p.locator('#resource-password').isVisible());
  await p.locator('#resource-agreement').uncheck();
  assert.ok(await p.locator('#resource-password').isHidden());
  for (const [query,count] of [['CHEMISTRY',2],['short notes',3],['Graded Exams',1],['nonexistent',0],['',4]]) {
    await p.locator('#resource-search').fill(query);
    assert.equal(await p.locator('.resource-row:visible').count(),count);
    assert.equal(await p.locator('#resource-count').textContent(),`Showing ${count} documents`);
  }
  await p.screenshot({path:path.join(root,'test-results/resources-desktop.png')});
  await p.context().close();
});

test('contact validates locally, preserves failed messages, and accepts confirmed success',async()=>{
  const p=await page({reducedMotion:'reduce'});await loaded(p);
  await p.getByRole('button',{name:'Send',exact:true}).click();
  assert.equal(await p.locator('[aria-invalid=true]').count(),3);
  await p.locator('#name').fill(' Test Name ');
  await p.locator('#email').fill('test@example.com');
  await p.locator('#message').fill('A test message');
  await p.getByRole('button',{name:'Send',exact:true}).click();
  await p.locator('#email-fallback').waitFor({state:'visible'});
  assert.equal(await p.locator('#message').inputValue(),'A test message');
  assert.ok((await p.locator('#email-fallback').getAttribute('href')).includes('test%40example.com'));
  await p.unroute('https://formsubmit.co/**');
  await p.route('https://formsubmit.co/**',async route=>{
    const payload=route.request().postDataJSON();
    assert.equal(payload.name,'Test Name');assert.equal(payload._replyto,'test@example.com');
    await route.fulfill({status:200,contentType:'application/json',body:JSON.stringify({success:true,message:'Message delivered'})});
  });
  await p.getByRole('button',{name:'Send',exact:true}).click();
  await p.locator('#form-status.success').waitFor();
  assert.equal(await p.locator('#message').inputValue(),'');
  assert.ok(await p.locator('#email-fallback').isHidden());
  await p.context().close();
});

test('activation-required responses are not reported as success',async()=>{
  const p=await page();await loaded(p);
  await p.route('https://formsubmit.co/**',route=>route.fulfill({status:200,contentType:'application/json',body:JSON.stringify({success:'true',message:'Please activate your form'})}));
  await p.locator('#name').fill('Test');await p.locator('#email').fill('test@example.com');await p.locator('#message').fill('Keep this message');
  await p.getByRole('button',{name:'Send',exact:true}).click();
  await p.locator('#email-fallback').waitFor({state:'visible'});
  assert.equal(await p.locator('#message').inputValue(),'Keep this message');
  await p.context().close();
});

test('mobile, tablet, and desktop layouts do not overflow',async()=>{
  const p=await page({reducedMotion:'reduce'});
  for (const width of [320,390,768,1024,1440]) {
    await p.setViewportSize({width,height:844});
    for (const route of ['/','/projects/','/resources/','/projects/ctsignals/']) {
      await loaded(p,route);await noOverflow(p);
      if (width===390) await p.screenshot({path:path.join(root,`test-results/mobile-${route.split('/')[1]||'home'}${route.includes('ctsignals')?'-reader':''}.png`)});
    }
  }
  await p.context().close();
});

test('static pages remain readable without JavaScript',async()=>{
  const p=await page({javaScriptEnabled:false});
  await p.goto(origin+'/');assert.equal(await p.locator('.profile-card').count(),7);
  await p.goto(origin+'/projects/opamp/');assert.ok(await p.locator('[data-reader-content]').isVisible());
  await p.goto(origin+'/resources/');assert.equal(await p.locator('.resource-row').count(),4);
  await p.context().close();
});

test('wheel animation moves the page and respects reduced motion',async()=>{
  const p=await page();await loaded(p);await p.mouse.move(1100,600);
  await p.mouse.wheel(0,600);
  await p.waitForFunction(()=>scrollY>590);
  await p.emulateMedia({reducedMotion:'reduce'});
  await p.evaluate(()=>scrollTo({top:0,behavior:'instant'}));
  await p.mouse.wheel(0,300);
  await p.waitForFunction(()=>scrollY>=299);
  assert.equal(await p.locator('.hero').evaluate(el=>getComputedStyle(el).opacity),'1');
  await p.context().close();
});

test('relative navigation also works when hosted under a subdirectory',async()=>{
  const nested=spawn(process.execPath,['scripts/serve.mjs'],{cwd:root,env:{...process.env,PORT:'4184',PREVIEW_ROOT:path.dirname(root)},stdio:['ignore','pipe','pipe']});
  try {
    await once(nested.stdout,'data');
    const p=await page();
    await p.goto('http://127.0.0.1:4184/Alt/dist/');
    await p.getByRole('link',{name:'Projects',exact:true}).click();
    await p.locator('.project-tile').first().click();
    await p.locator('[data-reader-content]').waitFor();
    assert.ok(new URL(p.url()).pathname.startsWith('/Alt/dist/projects/'));
    await p.reload();await p.locator('[data-reader-content]').waitFor();
    await p.getByRole('link',{name:'Resources',exact:true}).click();
    assert.equal(await p.locator('.resource-row').count(),4);
    await p.context().close();
  } finally {nested.kill();}
});
