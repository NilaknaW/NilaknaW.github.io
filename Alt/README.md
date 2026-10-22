# Nilakna's portfolio — HTML version

A static HTML, CSS, and vanilla JavaScript implementation of the active Flutter app in `../nilaknaw`. There is no Flutter, Astro, or client-side framework runtime. A small Node build script shares the page layout and converts the original Markdown to HTML with KaTeX equations.

## Run locally

Requires Node.js 20 or newer.

```sh
cd Alt
npm ci
npm run build
npm run dev
```

Open http://127.0.0.1:4173/. The server creates the first build if `dist/` is missing. After editing source files, run `npm run build` and refresh the browser. `npm run preview` serves the same output.

## Content and behavior

- Home: introduction, 16 skill icons, research and publications, seven profile cards, resume and contact links, and the contact form.
- Projects: all 10 projects, three posts, three articles, eight achievements, and complete Markdown readers with tables, links, sized images, and equations.
- Resources: the four original study notes, grouped search results, consent checkbox, and password reveal/reset.
- Original `projects/?project=assets/markdown/…` URLs, browser history, reader retry, and `/blog`, `/about`, and `/publications` redirects.
- Original images, the exact Roboto Slab font, and subsetted original icon fonts stored locally. The Make-a-thon article's misspelled image reference is resolved to the existing image.
- Responsive layouts, wheel smoothing, section fades, reduced-motion support, keyboard navigation, and selectable text.

The contact form uses the original FormSubmit endpoint and acceptance checks. Unconfirmed requests retain the message and offer a prefilled direct-email link. Delivery still depends on that existing service and its activation status; automated tests mock requests and never send real email.

## Edit

- `content/site.json`: project lists, profile text, citations, awards, resources, and icon mapping.
- `public/assets/markdown/`: original Markdown and its illustrations.
- `public/assets/images/`: profile and achievement images.
- `public/styles.css`: styling and responsive layouts.
- `public/app.js`: reader navigation, search, password reveal, scrolling, and contact handling.
- `scripts/build.mjs`: shared HTML layout, page templates, Markdown rendering, and metadata.

`dist/` is generated and is replaced on each build. Edit the source files above. Unused Flutter pages, commented sections, duplicate components, unused assets, and compatibility widgets are omitted.

## Verify

```sh
npm test
```

The browser tests cover content, all 16 readers and their images, equations, direct URLs and history, reader failures/retry, search, consent, contact validation and mocked responses, reduced motion, nested hosting, and layouts at 320, 390, 768, 1024, and 1440 pixels. Screenshots are saved in ignored `test-results/`.

On Windows, tests use installed Chrome. Set `BROWSER_PATH` to another Chromium executable, or install Playwright's browser with `npx playwright install chromium` on other platforms.

## Static hosting

Upload the **contents of `dist/`** to any static host, including GitHub Pages. Directory indexes support direct page loads without a server rewrite. Each reader also has a standalone HTML URL (`projects/opamp/`, for example) and can be read without JavaScript.

The default canonical origin matches the Flutter site, `https://nilaknaw.github.io`. For a different domain or subdirectory, set `SITE_URL` before building, for example in PowerShell:

```powershell
$env:SITE_URL = 'https://example.com/portfolio'
npm run build
```

This implementation is local to `Alt`; no publishing or changes to the existing Flutter app are required.

Roboto Slab and Material Icons are by Google; brand glyphs are from Simple Icons. Their license files are included in `public/assets/fonts/`. The build includes KaTeX's license alongside its assets.
