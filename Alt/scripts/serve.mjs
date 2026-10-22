import http from 'node:http';
import path from 'node:path';
import { readFile, stat } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const root = path.resolve(process.env.PREVIEW_ROOT || path.join(projectRoot,'dist'));
const port = Number(process.env.PORT || 4173);
const mime = {'.html':'text/html; charset=utf-8','.css':'text/css; charset=utf-8','.js':'text/javascript; charset=utf-8','.json':'application/json','.png':'image/png','.jpeg':'image/jpeg','.jpg':'image/jpeg','.svg':'image/svg+xml','.woff':'font/woff','.woff2':'font/woff2','.ttf':'font/ttf','.wasm':'application/wasm','.xml':'application/xml','.txt':'text/plain; charset=utf-8','.md':'text/plain; charset=utf-8'};
try { await stat(path.join(root,'index.html')); } catch { if (!process.env.PREVIEW_ROOT) await import('./build.mjs'); }
const server = http.createServer(async (request,response) => {
  try {
    const url = new URL(request.url,'http://localhost');
    const filename = path.resolve(root,'.'+decodeURIComponent(url.pathname));
    if (filename !== root && !filename.startsWith(root+path.sep)) { response.writeHead(403).end(); return; }
    let file = filename;
    const info = await stat(file);
    if (info.isDirectory()) {
      if (!url.pathname.endsWith('/')) {response.writeHead(301,{Location:url.pathname+'/'+url.search}).end();return;}
      file = path.join(file,'index.html');
    }
    const content = await readFile(file);
    response.writeHead(200,{'Content-Type':mime[path.extname(file).toLowerCase()]||'application/octet-stream','Cache-Control':'no-cache'});
    response.end(request.method === 'HEAD' ? undefined : content);
  } catch {
    response.writeHead(404,{'Content-Type':'text/plain; charset=utf-8'}).end('Not found');
  }
});
server.listen(port,'127.0.0.1',()=>console.log(`Local: http://127.0.0.1:${port}/`));
for (const signal of ['SIGINT','SIGTERM']) process.on(signal,()=>server.close(()=>process.exit(0)));
