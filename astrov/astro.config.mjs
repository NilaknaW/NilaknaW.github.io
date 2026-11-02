import { defineConfig } from "astro/config";
import { unified } from "@astrojs/markdown-remark";
import sitemap from "@astrojs/sitemap";
import remarkMath from "remark-math";
import rehypeKatex from "rehype-katex";
import portfolioMarkdown from "./src/lib/portfolio-markdown.mjs";

export default defineConfig({
  site: "https://nilaknaw.github.io",
  output: "static",
  // Accept old Flutter links without a slash as well as directory URLs.
  trailingSlash: "ignore",
  compressHTML: true,
  integrations: [
    sitemap({ filter: (url) => !/\/(about|blog|publications)\/$/.test(url) }),
  ],
  redirects: {
    "/about": "/",
    "/publications": "/",
    "/blog": "/projects/",
  },
  markdown: {
    processor: unified({
      smartypants: false,
      remarkPlugins: [remarkMath, portfolioMarkdown],
      rehypePlugins: [[rehypeKatex, { strict: false }]],
    }),
    syntaxHighlight: false,
  },
});
