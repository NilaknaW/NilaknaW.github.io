import { readFile, writeFile, mkdir, cp, rm } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import MarkdownIt from 'markdown-it';
import katex from 'katex';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const out = path.join(root, 'dist');
const data = JSON.parse(await readFile(path.join(root, 'content/site.json'), 'utf8'));
const siteName = 'Nilakna Warushavithana';
const origin = (process.env.SITE_URL || 'https://nilaknaw.github.io').replace(/\/$/, '');
const description = 'Nilakna Warushavithana is an Electronic and Telecommunication Engineering undergraduate interested in analog and mixed-signal circuits, IC design, optoelectronics, sensing, and experimental instrumentation.';
const escape = value => String(value).replace(/[&<>"']/g, c => ({'&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;'}[c]));
const icon = name => `<span class="icon ${data.icons[name].family}" aria-hidden="true">&#${data.icons[name].code};</span>`;
const external = (url, label, cls = '') => `<a href="${escape(url)}" target="_blank" rel="noopener noreferrer"${cls ? ` class="${cls}"` : ''}>${label}</a>`;
const md = new MarkdownIt({ html: false, linkify: true });
md.inline.ruler.before('escape', 'math', (state, silent) => {
  const rest = state.src.slice(state.pos);
  const match = /^(?:\$\$([\s\S]+?)\$\$|\\\[([\s\S]+?)\\\]|\\\(([\s\S]+?)\\\)|\$([^\n$]+?)\$)/.exec(rest);
  if (!match) return false;
  if (!silent) {
    const token = state.push('math', '', 0);
    token.content = match[1] ?? match[2] ?? match[3] ?? match[4];
    token.meta = { display: match[1] != null || match[2] != null };
  }
  state.pos += match[0].length;
  return true;
});
md.renderer.rules.math = (tokens, index) => katex.renderToString(tokens[index].content.trim(), {
  displayMode: tokens[index].meta.display, throwOnError: false, strict: false, trust: false,
});
md.renderer.rules.image = (tokens, index) => {
  const token = tokens[index];
  const size = /^\s*(?:(\d+)(?:x(\d+))?|x(\d+))(?=\s|$)/.exec(token.content);
  const label = size ? token.content.slice(size[0].length).trim() : token.content;
  const width = Number(size?.[1]) || null;
  const height = Number(size?.[2] || size?.[3]) || null;
  const src = token.attrGet('src').replace('https://raw.githubusercontent.com/NilaknaW/NilaknaW.github.io/main/assets/assets/', 'assets/');
  return `<img src="${escape(src)}" alt="${escape(label)}" loading="lazy"${width ? ` width="${width}"` : ''}${height ? ` height="${height}"` : ''}${height ? ` style="max-height:${height}px;object-fit:contain"` : ''}>`;
};
const originalLink = md.renderer.rules.link_open || ((tokens, idx, options, env, self) => self.renderToken(tokens, idx, options));
md.renderer.rules.link_open = (tokens, index, options, env, self) => {
  if (/^https?:/.test(tokens[index].attrGet('href'))) {
    tokens[index].attrSet('target', '_blank');
    tokens[index].attrSet('rel', 'noopener noreferrer');
  }
  return originalLink(tokens, index, options, env, self);
};

function layout({ page = 'Home', title = siteName, body, route = '', base = './', desc = description, project = null }) {
  const canonical = `${origin}/${route}`;
  const pageSchema = { '@context':'https://schema.org', '@type':'WebPage', name:title, description:desc, url:canonical, about:{'@id':`${origin}/#person`} };
  const person = {'@context':'https://schema.org', '@type':'Person', '@id':`${origin}/#person`, name:siteName, url:`${origin}/`, image:`${origin}/assets/images/chi1.png`, sameAs:['https://github.com/NilaknaW', 'https://linkedin.com/in/nilakna-warushavithana', 'https://orcid.org/0009-0009-7133-2022']};
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><base href="${base}">
<title>${escape(title)}</title><meta name="description" content="${escape(desc)}"><meta name="theme-color" content="#e0f2f1">
<link rel="icon" href="assets/images/favicon.png"><link rel="canonical" href="${escape(canonical)}">
<meta property="og:type" content="website"><meta property="og:title" content="${escape(title)}"><meta property="og:description" content="${escape(desc)}"><meta property="og:url" content="${escape(canonical)}"><meta property="og:image" content="${origin}/assets/images/chi1.png">
<meta name="twitter:card" content="summary"><meta name="twitter:title" content="${escape(title)}"><meta name="twitter:description" content="${escape(desc)}">
<link rel="preload" href="assets/fonts/roboto-slab-400.woff" as="font" type="font/woff" crossorigin>
<link rel="stylesheet" href="styles.css"><link rel="stylesheet" href="assets/katex/katex.min.css">
<script id="page-schema" type="application/ld+json">${JSON.stringify(pageSchema).replace(/</g, '\\u003c')}</script>
<script type="application/ld+json">${JSON.stringify(person)}</script><script src="app.js" defer></script></head>
<body data-page="${page}"${project ? ` data-project="${escape(project.markdownAssetPath)}"` : ''}>
<a class="skip-link" href="${project ? `projects/${project.slug}/` : route}#main">Skip to content</a>
<header class="app-bar"><a class="logo" href="./" aria-label="Nilakna Warushavithana — Home"><img src="assets/images/favicon.png" width="40" height="40" alt=""></a>
<nav aria-label="Main navigation">${['Home','Projects','Resources'].map(p => `<a href="${p === 'Home' ? './' : p.toLowerCase() + '/'}"${p === page ? ' aria-current="page"' : ''}>${p}</a>`).join('')}</nav>
<div class="socials">${external('https://github.com/NilaknaW', `${icon('github')}<span class="sr-only">GitHub</span>`)}${external('https://linkedin.com/in/nilakna-warushavithana', '<img src="assets/images/linkedin.svg" width="16" height="16" alt="LinkedIn">')}</div></header>
<main id="main" tabindex="-1">${body}</main></body></html>`;
}

function home() {
  const profile = item => `<article class="profile-card${item.reverse ? ' reverse' : ''}"><img src="${item.imagePath}" alt="${escape(item.title)}" loading="lazy"><div><h3>${escape(item.title)}</h3><p>${escape(item.description).replace(/\n/g, '<br>')}</p></div></article>`;
  const group = (title, items) => `<h3 class="subheading">${title}</h3>${items.map(profile).join('')}`;
  const contacts = [
    ['email', 'Email', 'warushavithanand.22@uom.lk', 'mailto:warushavithanand.22@uom.lk'],
    ['code', 'GitHub', 'github.com/NilaknaW', 'https://github.com/NilaknaW'],
    ['business', 'LinkedIn', 'linkedin.com/in/nilakna-warushavithana', 'https://linkedin.com/in/nilakna-warushavithana'],
    ['assignment_ind_sharp', 'ORCID id', 'orcid.org/0009-0009-7133-2022', 'https://orcid.org/0009-0009-7133-2022'],
  ];
  return `<section class="hero fade-section"><div class="hero-introduction"><div class="hero-copy"><h1>I am Nilakna,</h1><p>an Electronic and Telecommunication Engineering undergraduate interested in <strong>analog and mixed-signal circuits, IC design, optoelectronics, sensing, and experimental instrumentation</strong>. I enjoy working at the intersection of physics and electronics.</p><div class="button-row">${external('https://drive.google.com/drive/folders/1oGzpCXVH44Q9vQw64gb3kvY6HqsIWYXG?usp=drive_link', `${icon('download')}Resume`, 'button elevated')}<a class="button elevated" href="#contact">${icon('mail')}Contact</a></div></div><div class="portrait-wrap"><img class="portrait" src="assets/images/chi1.png" alt="Nilakna Warushavithana" width="440" height="440" fetchpriority="high"></div></div>
<ul class="tools" aria-label="Tools and skills">${data.tools.map(tool => `<li tabindex="0" aria-label="${escape(tool.label)}" data-tooltip="${escape(tool.label)}">${icon(tool.icon)}</li>`).join('')}</ul></section>
<hr class="section-divider"><section class="section research fade-section"><h2>Research</h2><div class="research-intro">${md.render(data.citations[0])}</div><h3>Current Projects</h3>${data.citations.slice(1,3).map(c => `<div class="citation">${md.render(c)}</div>`).join('')}<h3>Publications</h3>${data.citations.slice(3).map(c => `<div class="citation publication">${md.render(c)}</div>`).join('')}</section>
<hr class="section-divider"><section class="section about fade-section"><h2>About Me</h2><div class="bio">${data.bio.split('\n\n').map(p => `<p>${escape(p)}</p>`).join('')}</div>${group('Experience', data.profiles.slice(0,3))}${group('Education & Leadership', data.profiles.slice(3,5))}${group('Beyond Research', data.profiles.slice(5))}</section>
<footer class="contact-section" id="contact"><div class="contact-columns"><div><h3>Reach Out</h3><div class="contact-links">${contacts.map(([i,label,text,url]) => `<a href="${url}"${url.startsWith('https:') ? ' target="_blank" rel="noopener noreferrer"' : ''}>${icon(i)}<span>${label}<small>${text}</small></span></a>`).join('')}</div></div>
<form id="contact-form" novalidate><h3>Send a Message</h3><div class="form-field"><label for="name">Your Name</label><input id="name" name="name" autocomplete="name" required><span class="field-error" id="name-error"></span></div><div class="form-field"><label for="email">Your Email</label><input id="email" name="email" type="email" autocomplete="email" required><span class="field-error" id="email-error"></span></div><div class="form-field"><label for="message">Message</label><textarea id="message" name="message" rows="4" required></textarea><span class="field-error" id="message-error"></span></div><button class="button outlined" type="submit">${icon('send')}<span class="send-label">Send</span></button><p id="form-status" role="status" aria-live="polite" hidden></p><a id="email-fallback" class="text-button" href="mailto:nilawarush@gmail.com" hidden>Email me directly</a><noscript><p>Please <a href="mailto:nilawarush@gmail.com">email me directly</a> to send a message.</p></noscript></form></div><hr><p class="credit">Made with ${icon('favorite')} by Nilakna Warushavithana. 2025.</p></footer>`;
}

const allProjects = data.sections.flatMap(section => section.items).map(project => ({...project, slug: path.basename(project.markdownAssetPath, '.md')}));
function grid() {
  return `<div id="projects-grid">${data.sections.map((section,index) => `<section class="project-section section"><h${index ? '2' : '1'}>${section.title}</h${index ? '2' : '1'}><div class="project-grid ${index ? 'compact-grid' : ''}">${section.items.map(project => `<a class="project-tile" href="projects/?project=${encodeURIComponent(project.markdownAssetPath)}" data-project="${escape(project.markdownAssetPath)}"><img src="${project.imagePath}" alt="" loading="lazy"><span>${escape(project.title)}</span></a>`).join('')}</div></section>`).join('')}
<section class="section awards"><h2>Competition Achievements</h2><div class="award-grid">${data.awards.map(award => `<article class="award-card"><img src="${award.imagePath}" alt="${escape(award.title)}" loading="lazy"><div><h3>${escape(award.title)}</h3><p class="award-field">${escape(award.field)}</p><p>${escape(award.placement)} • ${award.year}</p></div></article>`).join('')}</div></section></div>
<div id="project-reader" hidden></div><noscript><p class="section">Project readers: ${allProjects.map(p => `<a href="projects/${p.slug}/">${escape(p.title)}</a>`).join(' · ')}</p></noscript><script id="project-data" type="application/json">${JSON.stringify(allProjects).replace(/</g, '\\u003c')}</script>`;
}
function reader(project, html) {
  return `<div class="reader-toolbar"><a class="text-button all-projects" href="projects/">${icon('arrow_back')}All projects</a><span>${escape(project.title)}</span></div><div class="reader-background"><article class="markdown" data-reader-content>${html}</article></div>`;
}
function resources() {
  const groups = Map.groupBy ? Map.groupBy(data.resources, r => `${r.level} / ${r.subject}`) : data.resources.reduce((m,r) => {const k=`${r.level} / ${r.subject}`; m.set(k,[...(m.get(k)||[]),r]); return m;},new Map());
  return `<section class="section resources"><h1>Resources</h1><div class="resource-content"><div class="resource-access"><p>These are my study notes from different exams. Notes are based on school, tuition, books, and lots of self-learning :)</p><label class="agreement"><input id="resource-agreement" type="checkbox"><span>I agree to use these documents only for personal study and not for commercial purposes.</span></label><div class="button-row"><button id="show-password" class="button outlined" disabled>${icon('lock_open')}Agree and Show Password</button><output id="resource-password" hidden>student-resources</output></div></div><div class="search-field">${icon('search')}<input id="resource-search" type="search" aria-label="Search by subject, topic, type, or level" placeholder="Search by subject, topic, type, or level"></div><p id="resource-count" role="status" aria-live="polite">Showing 4 documents</p><div class="resource-groups">${[...groups].map(([title,items]) => `<section class="resource-group"><h2>${escape(title)}</h2>${items.map(item => `<a class="resource-row" href="${escape(item.link)}" target="_blank" rel="noopener noreferrer" data-search="${escape([item.level,item.subject,item.title,item.type].join(' ').toLowerCase())}"><span>${escape(item.title)}</span>${icon('open_in_new')}</a>`).join('')}</section>`).join('')}</div><p id="resource-empty" hidden>No resources found.</p></div></section>`;
}

// Clean only this project's fixed, generated output directory.
if (path.relative(root,out) !== 'dist') throw new Error('Unexpected output directory');
await rm(out,{recursive:true,force:true});
await mkdir(out, {recursive:true});
await cp(path.join(root, 'public'), out, {recursive:true});
await mkdir(path.join(out,'assets/katex'), {recursive:true});
await cp(path.join(root,'node_modules/katex/dist/katex.min.css'), path.join(out,'assets/katex/katex.min.css'));
await cp(path.join(root,'node_modules/katex/dist/fonts'), path.join(out,'assets/katex/fonts'), {recursive:true});
await cp(path.join(root,'node_modules/katex/LICENSE'), path.join(out,'assets/katex/LICENSE.txt'));
async function emit(route, html) { const file=path.join(out,route,'index.html'); await mkdir(path.dirname(file),{recursive:true}); await writeFile(file,html); }
await emit('',layout({body:home()}));
await emit('projects', layout({page:'Projects', title:`Projects | ${siteName}`, desc:'Explore engineering projects, research articles and technical notes by Nilakna Warushavithana, from analog IC design to embedded systems and robotics.', route:'projects/', base:'../', body:grid()}));
await emit('resources', layout({page:'Resources',title:`Study Resources | ${siteName}`,desc:'Study resources and notes in physics, chemistry and music shared by Nilakna Warushavithana.',route:'resources/',base:'../',body:resources()}));
for (const project of allProjects) {
  const html=md.render(await readFile(path.join(root,'public',project.markdownAssetPath),'utf8'));
  await emit(`projects/${project.slug}`,layout({page:'Projects', title:`${project.title} | ${siteName}`, desc:`${project.title}: project notes and technical details by ${siteName}.`,route:`projects/?project=${encodeURIComponent(project.markdownAssetPath)}`,base:'../../',project,body:reader(project,html)}));
}
for (const [old,to] of [['about',''],['publications',''],['blog','projects/']]) await emit(old,`<!doctype html><html lang="en"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../${to}"><title>Redirecting | ${siteName}</title></head><body><a href="../${to}">Continue to ${to || 'Home'}</a></body></html>`);
await writeFile(path.join(out,'404.html'),layout({title:`Page not found | ${siteName}`,body:'<section class="section"><h1>Page not found</h1><p><a href="./">Return home</a></p></section>'}));
await writeFile(path.join(out,'sitemap.xml'),`<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${['','projects/','resources/',...allProjects.map(p=>`projects/?project=${encodeURIComponent(p.markdownAssetPath)}`)].map(route=>`<url><loc>${escape(origin+'/'+route)}</loc></url>`).join('')}</urlset>`);
await writeFile(path.join(out,'robots.txt'),`User-agent: *\nAllow: /\nSitemap: ${origin}/sitemap.xml\n`);
await writeFile(path.join(out,'.nojekyll'),'');
console.log(`Built Home, Projects, Resources, ${allProjects.length} readers, and legacy redirects in Alt/dist.`);
