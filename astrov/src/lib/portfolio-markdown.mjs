// Preserve Flutter's optional image sizes: ![500 Description](/assets/photo.jpg).
// Plain Markdown images work too. This runs at build time, never in the browser.
export default function portfolioMarkdown() {
  return function visit(node) {
    if (node.type === "image") {
      const size = /^\s*(?:(\d+)(?:x(\d+))?|x(\d+))(?=\s|$)/.exec(
        node.alt || "",
      );
      const width = Number(size?.[1]) || undefined;
      const height = Number(size?.[2] || size?.[3]) || undefined;
      if (size) node.alt = node.alt.slice(size[0].length).trim();
      node.data ??= {};
      node.data.hProperties = {
        ...node.data.hProperties,
        loading: "lazy",
        ...(width && { width }),
        ...(height && {
          height,
          style: `max-height:${height}px;object-fit:contain`,
        }),
      };
    }
    if (node.type === "link" && /^https?:/.test(node.url)) {
      node.data ??= {};
      node.data.hProperties = { target: "_blank", rel: "noopener noreferrer" };
    }
    node.children?.forEach(visit);
  };
}
