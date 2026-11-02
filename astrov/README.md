# Nilakna's portfolio — Astro

A static Astro version of the active Flutter website in `../nilaknaw`, preserving its Home, Projects, and Resources content, images, Roboto Slab font, teal styling, and interactions. The project is independent of the Flutter and `Alt` folders: you only edit files inside `astrov` from now on.

Astro generates ordinary HTML, CSS, and a little JavaScript. There is no server, database, React, or Flutter runtime to deploy. Markdown is well suited to the descriptions, so it stays editable as Markdown and is rendered during the build, including tables and equations.

## Run locally

Install **Node.js 24 LTS** (the system's older Node 20 will not run this Astro version), then:

```sh
cd astrov
npm ci
npm run dev
```

Open the local URL printed in the terminal, usually `http://localhost:4321`. Changes refresh automatically. Stop the server with Ctrl+C.

```sh
npm run check   # Check Astro templates and content types
npm run build   # Generate the publishable dist/ folder
npm run preview # Preview that production build locally
```

Do not edit `dist/`, `.astro/`, or `node_modules/`; they are generated. The ignored `.tools/` directory, if present in this checkout, contains migration-time utilities and a local Node runtime. It is not part of the website and is not needed after installing Node 24 normally.

## File structure

```text
astrov/
├── astro.config.mjs           # Site URL, redirects, Markdown and sitemap setup
├── package.json               # Commands and dependencies
├── package-lock.json          # Reproducible dependency versions; commit this
├── public/
│   ├── assets/
│   │   ├── images/            # Portrait, profile and achievement images
│   │   ├── markdown/          # Existing project illustrations
│   │   └── fonts/             # Local fonts and their licenses
│   ├── robots.txt
│   └── flutter_service_worker.js # Retires the previous Flutter offline cache
├── src/
│   ├── content.config.ts     # Required project metadata and allowed categories
│   ├── content/
│   │   ├── research.md       # Research interests, current work, publications
│   │   └── projects/*.md     # One file per project, post, or article
│   ├── data/
│   │   ├── site.json         # Biography, profiles, awards, resources, skills
│   │   └── icons.json        # Existing icon font character mapping
│   ├── components/          # Contact form, profile card, icon
│   ├── layouts/Layout.astro # Shared header, navigation, metadata and font CSS
│   ├── pages/
│   │   ├── index.astro      # Home
│   │   ├── projects/
│   │   │   ├── index.astro  # Project/post/article grids and achievements
│   │   │   └── [id].astro   # Generates a reader for each Markdown file
│   │   ├── resources.astro # Study notes and search
│   │   └── 404.astro
│   ├── styles/global.css   # Shared styles, grouped by page/component
│   ├── scripts/            # Contact, resource search, scrolling and fades
│   └── lib/portfolio-markdown.mjs # Optional image sizes and external links
└── tests/site.test.mjs      # Browser checks for the migration

../.github/workflows/deploy-astro.yml # GitHub Pages build and deployment
```

## Add a project, post, or article

1. Put the cover and other images in `public/assets/`, for example `public/assets/images/my-project.jpg`.
2. Create `src/content/projects/my-project.md`:

```markdown
---
title: "My new project"
category: "Projects"
order: 11
image: "/assets/images/my-project.jpg"
description: "A short description for search engines and sharing."
---

# My new project

November 2, 2026

Explain what you built, your contribution, and the results.

## Design

![500 A descriptive image caption](/assets/images/my-project.jpg)

[Source code](https://github.com/NilaknaW/my-project)
```

3. Save. Astro automatically adds the card and creates `/projects/my-project/`. No route or project-list changes are needed.

Use `Projects`, `Posts`, or `Articles` for `category`. Lower `order` numbers appear first within that category. Use a unique lowercase, hyphenated filename: it becomes the URL, so keep published filenames stable. `description` is optional. Existing entries have a `legacyPath` to preserve old Flutter query links; omit it for new entries.

An image URL begins with `/assets/`, **not** `public/`. Filenames are case-sensitive on GitHub Pages, even though Windows may accept a different case. Normal `![Caption](/assets/photo.jpg)` syntax works. The existing optional `500` prefix sets the image width in pixels; `500x300` or `x300` also work. Images shrink to fit smaller screens.

Write inline equations as `$V = IR$` and display equations between `$$` on separate lines. The migration converted the old `\[ ... \]` display delimiters to `$$` and made project images local. A misspelled source image filename was corrected in the copied assets. No descriptions were replaced with summaries.

## Update other content

| What to change                                 | File                                                               |
| ---------------------------------------------- | ------------------------------------------------------------------ |
| Introduction, resume link, home section layout | `src/pages/index.astro`                                            |
| Research interests and publications            | `src/content/research.md`                                          |
| Biography, experience, education, interests    | `src/data/site.json` (`bio`, `profiles`)                           |
| Competition achievements                       | `src/data/site.json` (`awards`)                                    |
| Study-note links and search terms              | `src/data/site.json` (`resources`)                                 |
| Skill tooltips/icons                           | `src/data/site.json` (`tools`) and `src/data/icons.json`           |
| Contact links                                  | `src/components/Contact.astro`                                     |
| Contact form recipient                         | `src/scripts/contact.js` and the fallback links in `Contact.astro` |
| Resource password                              | `src/pages/resources.astro`                                        |
| Colours, spacing, typography, mobile layouts   | `src/styles/global.css`                                            |
| Navigation and shared metadata                 | `src/layouts/Layout.astro`                                         |

To add an achievement, profile, or resource, copy an object in the corresponding JSON array and update its values. For profiles, use `Experience`, `Education & Leadership`, or `Beyond Research` as the `group`; `reverse: true` puts the image on the right on wide screens. Resource grouping, search and document counts update automatically. The resource password reveal preserves the original consent interaction; it is a public convenience, not access control.

The contact form uses the original `formsubmit.co` endpoint and recipient. Failed or unconfirmed responses preserve the message and offer direct email. Delivery requires that service and its recipient activation to work. Automated checks mock requests and never send a real message.

## Publish on GitHub Pages

The repository-level workflow builds **only `astrov`** and publishes **only `astrov/dist`**. The existing Flutter source and compiled files do not need to be deleted or overwritten. For this user repository, the website is served at `https://nilaknaw.github.io/`, not `/astrov/`.

1. Commit `astrov/` and `.github/workflows/deploy-astro.yml` and push them to the repository's `main` branch.
2. On GitHub, open **Settings → Pages → Build and deployment → Source**, and select **GitHub Actions**.
3. Open **Actions → Deploy Astro to GitHub Pages → Run workflow**, select `main`, and run it. Later changes to `astrov` on `main` deploy automatically.
4. Wait for the build and deploy jobs to succeed, then visit `https://nilaknaw.github.io/`.

If the default branch is not `main`, change the workflow's branch filter. If another workflow also deploys this site's Pages output, disable that competing deployment when switching over. The small `public/flutter_service_worker.js` retires the original Flutter cache for returning visitors; keep it during migration.

The workflow must live in the **repository root** `.github/workflows/`, not inside `astrov`. GitHub's root or `/docs` branch-publishing options cannot directly build Astro; use the workflow. There is no need to commit `dist/`. The site assumes hosting at the domain root; deploying under another repository's subpath would also require prefixing root-relative links and asset URLs.

Reference: [Astro's GitHub Pages deployment guide](https://docs.astro.build/en/guides/deploy/github/).

## Browser verification and formatting

```sh
npm run build
npm test
npm run format
```

Browser checks use installed Google Chrome on Windows. Elsewhere, run `npx playwright install chromium` first, or set `BROWSER_PATH` to an existing Chromium executable. Screenshots go to the ignored `test-results/` directory. Checks cover all readers and images, equations, old URLs, responsive layouts, resource search, contact validation, and use without JavaScript.

Stop a running `npm run preview` before `npm test`; Astro permits one preview server per project. A development server (`npm run dev`) can remain open.

Roboto Slab and Material Icons are by Google; brand icons are from Simple Icons. Their licenses are in `public/assets/fonts/`. Equations use KaTeX.
