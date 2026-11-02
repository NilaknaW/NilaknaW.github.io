import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

const projects = defineCollection({
  loader: glob({ pattern: "*.md", base: "./src/content/projects" }),
  schema: z.object({
    title: z.string(),
    category: z.enum(["Projects", "Posts", "Articles"]),
    order: z.number(),
    image: z.string().startsWith("/assets/"),
    description: z.string().optional(),
    // Only migrated entries need this, to keep old Flutter links working.
    legacyPath: z.string().optional(),
  }),
});

export const collections = { projects };
