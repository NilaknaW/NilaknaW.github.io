const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)');
const base = new URL(document.baseURI);
const updateAppBar = () => document.body.classList.toggle('scrolled',scrollY > 0);
addEventListener('scroll',updateAppBar,{passive:true});
updateAppBar();
document.querySelector('.skip-link')?.addEventListener('click',event=>{
  event.preventDefault();
  document.querySelector('#main').focus({preventScroll:true});
  scrollTo({top:0,behavior:reducedMotion.matches?'instant':'smooth'});
});

// Match the source wheel animation; leave nested scrollers and touch input native.
let wheelFrame = 0, wheelTarget = 0, wheelTime = 0;
function stopWheel() { cancelAnimationFrame(wheelFrame); wheelFrame = 0; }
function wheelTick(time) {
  const elapsed = Math.min((time - wheelTime) / 1000, .1);
  wheelTime = time;
  wheelTarget = Math.max(0, Math.min(wheelTarget, document.documentElement.scrollHeight - innerHeight));
  const remaining = wheelTarget - scrollY;
  if (Math.abs(remaining) < .2) { scrollTo({top:wheelTarget,behavior:'instant'}); wheelFrame = 0; return; }
  scrollTo({top:scrollY + remaining * (1 - Math.exp(-elapsed * 18)),behavior:'instant'});
  wheelFrame = requestAnimationFrame(wheelTick);
}
addEventListener('wheel', event => {
  if (reducedMotion.matches || event.ctrlKey || event.shiftKey || Math.abs(event.deltaX) > Math.abs(event.deltaY) || !event.deltaY) return;
  if (event.target.closest('textarea,input,.app-bar,pre,table,.katex-display')) return;
  for (let node = event.target; node instanceof Element && node !== document.body; node = node.parentElement) {
    if (node.scrollHeight > node.clientHeight && /(auto|scroll)/.test(getComputedStyle(node).overflowY)) return;
  }
  const delta = event.deltaY * (event.deltaMode === 1 ? 20 : event.deltaMode === 2 ? innerHeight : 1);
  const limit = document.documentElement.scrollHeight - innerHeight;
  if (limit <= 0 || (scrollY <= 0 && delta < 0) || (scrollY >= limit && delta > 0)) return;
  event.preventDefault();
  wheelTarget = Math.max(0, Math.min((wheelFrame && (wheelTarget-scrollY)*delta > 0 ? wheelTarget : scrollY)+delta,limit));
  if (!wheelFrame) {wheelTime=performance.now();wheelFrame=requestAnimationFrame(wheelTick);}
},{passive:false});
for (const event of ['pointerdown','touchstart','keydown','popstate']) addEventListener(event,stopWheel,{passive:true});
reducedMotion.addEventListener('change',stopWheel);

// Preserve Flutter's section fades while allowing native touch and keyboard scrolling.
const sections = [...document.querySelectorAll('.fade-section')];
let fadeFrame = 0;
function updateFades() {
  fadeFrame = 0;
  for (const section of sections) {
    if (reducedMotion.matches) { section.style.opacity = '1'; continue; }
    const rect = section.getBoundingClientRect();
    const viewport = innerHeight - 80;
    const visible = Math.max(0, Math.min(rect.bottom, innerHeight) - Math.max(rect.top, 80));
    const fraction = Math.min(1, visible / (Math.min(rect.height, viewport) * .72));
    section.style.opacity = String(fraction * fraction * (3 - 2 * fraction));
  }
}
function scheduleFades() { if (!fadeFrame) fadeFrame = requestAnimationFrame(updateFades); }
if (sections.length) {
  addEventListener('scroll', scheduleFades, {passive:true});
  addEventListener('resize', scheduleFades);
  reducedMotion.addEventListener('change', scheduleFades);
  document.fonts.ready.then(scheduleFades);
  addEventListener('load', scheduleFades);
  updateFades();
}

const agreement = document.querySelector('#resource-agreement');
if (agreement) {
  const show = document.querySelector('#show-password');
  const password = document.querySelector('#resource-password');
  agreement.addEventListener('change', () => {
    show.disabled = !agreement.checked;
    if (!agreement.checked) password.hidden = true;
  });
  show.addEventListener('click', () => { if (agreement.checked) password.hidden = false; });
  document.querySelector('#resource-search').addEventListener('input', event => {
    const query = event.target.value.trim().toLowerCase();
    let count = 0;
    document.querySelectorAll('.resource-row').forEach(row => {
      row.hidden = !row.dataset.search.includes(query);
      if (!row.hidden) count++;
    });
    document.querySelectorAll('.resource-group').forEach(group => {
      group.hidden = !group.querySelector('.resource-row:not([hidden])');
    });
    document.querySelector('#resource-count').textContent = `Showing ${count} documents`;
    document.querySelector('#resource-empty').hidden = count > 0;
  });
}

const form = document.querySelector('#contact-form');
if (form) {
  let sending = false;
  const fields = ['name','email','message'];
  for (const name of fields) {
    const input = form.elements[name];
    input.placeholder = ' ';
    input.setAttribute('aria-describedby', `${name}-error`);
    input.addEventListener('input', () => {
      input.removeAttribute('aria-invalid');
      document.getElementById(`${name}-error`).textContent = '';
    });
  }
  form.addEventListener('submit', async event => {
    event.preventDefault();
    if (sending) return;
    const values = Object.fromEntries(fields.map(name => [name,form.elements[name].value.trim()]));
    const errors = {
      name: values.name ? '' : 'Please enter your name.',
      email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(values.email) ? '' : 'Please enter a valid email address.',
      message: values.message ? '' : 'Please enter a message.',
    };
    let invalid;
    for (const name of fields) {
      document.getElementById(`${name}-error`).textContent = errors[name];
      form.elements[name].setAttribute('aria-invalid', String(Boolean(errors[name])));
      if (errors[name]) invalid ||= form.elements[name];
    }
    if (invalid) { invalid.focus(); return; }
    const status = document.querySelector('#form-status');
    const fallback = document.querySelector('#email-fallback');
    const button = form.querySelector('button[type=submit]');
    const label = button.querySelector('.send-label');
    status.hidden = true;
    fallback.hidden = true;
    sending = true;
    form.setAttribute('aria-busy','true');
    button.disabled = true;
    fields.forEach(name => { form.elements[name].disabled = true; });
    label.textContent = 'Sending...';
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 20000);
    try {
      const response = await fetch('https://formsubmit.co/ajax/nilawarush@gmail.com', {
        method:'POST', headers:{'Content-Type':'application/json',Accept:'application/json'},
        body:JSON.stringify({...values,_replyto:values.email,_subject:'Portfolio contact message',_template:'table',_url:'https://nilaknaw.github.io/'}),
        signal:controller.signal,
      });
      const result = await response.json();
      if (!response.ok || ![true,'true'].includes(result?.success) || /activat|confirm.*email/i.test(result?.message || '')) throw new Error('Submission not accepted');
      form.reset();
      status.textContent = 'Message submitted. Thank you for reaching out!';
      status.classList.add('success');
    } catch {
      status.textContent = 'Your message could not be confirmed. Please email me directly.';
      status.classList.remove('success');
      fallback.href = `mailto:nilawarush@gmail.com?subject=${encodeURIComponent('Portfolio contact')}&body=${encodeURIComponent(`${values.name}\n${values.email}\n\n${values.message}`)}`;
      fallback.hidden = false;
    } finally {
      clearTimeout(timeout);
      sending = false;
      form.removeAttribute('aria-busy');
      fields.forEach(name => { form.elements[name].disabled = false; });
      button.disabled = false;
      label.textContent = 'Send';
      status.hidden = false;
    }
  });
}

const projectData = document.querySelector('#project-data');
if (projectData) {
  const projects = JSON.parse(projectData.textContent);
  const grid = document.querySelector('#projects-grid');
  const reader = document.querySelector('#project-reader');
  const originalSeo = {title:document.title, description:document.querySelector('meta[name=description]').content, canonical:document.querySelector('link[rel=canonical]').href};
  const cache = new Map();
  let request;
  let gridScroll = 0;
  let renderId = 0;
  const htmlEscape = value => String(value).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  function seo(title, description, canonical) {
    document.title = title;
    document.querySelector('link[rel=canonical]').href = canonical;
    for (const selector of ['meta[name=description]','meta[property="og:description"]','meta[name="twitter:description"]']) document.querySelector(selector).content = description;
    for (const selector of ['meta[property="og:title"]','meta[name="twitter:title"]']) document.querySelector(selector).content = title;
    document.querySelector('meta[property="og:url"]').content = canonical;
    const schema = JSON.parse(document.querySelector('#page-schema').textContent);
    Object.assign(schema,{name:title,description,url:canonical});
    document.querySelector('#page-schema').textContent = JSON.stringify(schema);
  }
  async function render({restore = false, focus = false} = {}) {
    const id = ++renderId;
    request?.abort();
    const asset = new URL(location.href).searchParams.get('project');
    const project = projects.find(p => p.markdownAssetPath === asset);
    if (!project) {
      grid.hidden = false;
      reader.hidden = true;
      document.body.removeAttribute('data-project');
      seo(originalSeo.title,originalSeo.description,originalSeo.canonical);
      if (restore) scrollTo({top:gridScroll,behavior:'instant'});
      if (focus) document.querySelector('#main').focus({preventScroll:true});
      return;
    }
    grid.hidden = true;
    reader.hidden = false;
    document.body.dataset.project = asset;
    seo(`${project.title} | Nilakna Warushavithana`, `${project.title}: project notes and technical details by Nilakna Warushavithana.`, `${originalSeo.canonical}?project=${encodeURIComponent(asset)}`);
    reader.innerHTML = '<p class="reader-loading" role="status">Loading notes…</p>';
    scrollTo({top:0,behavior:'instant'});
    try {
      let html = cache.get(asset);
      if (!html) {
        request = new AbortController();
        const response = await fetch(new URL(`projects/${project.slug}/`,base),{signal:request.signal});
        if (!response.ok) throw new Error('Reader unavailable');
        const page = new DOMParser().parseFromString(await response.text(),'text/html');
        if (!page.querySelector('[data-reader-content]')) throw new Error('Missing reader');
        html = page.querySelector('main').innerHTML;
        cache.set(asset,html);
      }
      if (id !== renderId) return;
      reader.innerHTML = html;
      if (focus) document.querySelector('#main').focus({preventScroll:true});
    } catch (error) {
      if (error.name === 'AbortError' || id !== renderId) return;
      reader.innerHTML = `<div class="reader-toolbar"><a class="text-button all-projects" href="projects/">← All projects</a><span>${htmlEscape(project.title)}</span></div><div class="reader-error" role="alert"><p>Could not load these notes.</p><button class="button outlined" id="retry-reader">Try again</button></div>`;
      document.querySelector('#retry-reader').addEventListener('click',()=>render({focus:true}));
    }
  }
  document.addEventListener('click', event => {
    const link = event.target.closest('a[data-project],a.all-projects');
    if (!link || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    event.preventDefault();
    if (link.dataset.project && !grid.hidden) gridScroll = scrollY;
    history.pushState(null,'',link.href);
    render({restore:!link.dataset.project,focus:true});
  });
  addEventListener('popstate',()=>render({restore:true,focus:true}));
  render();
}
