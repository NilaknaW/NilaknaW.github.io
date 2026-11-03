const more = document.querySelector(".nav-more");

if (more instanceof HTMLDetailsElement) {
  const toggle = more.querySelector("summary");

  more.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && more.open) {
      event.preventDefault();
      more.open = false;
      toggle.focus();
    }
  });

  document.addEventListener("click", (event) => {
    if (!more.contains(event.target)) more.open = false;
  });

  more.addEventListener("focusout", (event) => {
    if (!more.contains(event.relatedTarget)) more.open = false;
  });

  more.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      toggle.focus({ preventScroll: true });
      more.open = false;
    });
  });
}
