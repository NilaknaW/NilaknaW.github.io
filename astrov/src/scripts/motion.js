const reducedMotion = matchMedia("(prefers-reduced-motion: reduce)");
const updateAppBar = () =>
  document.body.classList.toggle("scrolled", scrollY > 0);
addEventListener("scroll", updateAppBar, { passive: true });
updateAppBar();
document.querySelector(".skip-link")?.addEventListener("click", (event) => {
  event.preventDefault();
  document.querySelector("#main").focus({ preventScroll: true });
  scrollTo({ top: 0, behavior: reducedMotion.matches ? "instant" : "smooth" });
});

// Match the source wheel animation; leave nested scrollers and touch input native.
let wheelFrame = 0,
  wheelTarget = 0,
  wheelTime = 0;
function stopWheel() {
  cancelAnimationFrame(wheelFrame);
  wheelFrame = 0;
}
function wheelTick(time) {
  const elapsed = Math.min((time - wheelTime) / 1000, 0.1);
  wheelTime = time;
  wheelTarget = Math.max(
    0,
    Math.min(wheelTarget, document.documentElement.scrollHeight - innerHeight),
  );
  const remaining = wheelTarget - scrollY;
  if (Math.abs(remaining) < 0.2) {
    scrollTo({ top: wheelTarget, behavior: "instant" });
    wheelFrame = 0;
    return;
  }
  scrollTo({
    top: scrollY + remaining * (1 - Math.exp(-elapsed * 18)),
    behavior: "instant",
  });
  wheelFrame = requestAnimationFrame(wheelTick);
}
addEventListener(
  "wheel",
  (event) => {
    if (
      reducedMotion.matches ||
      event.ctrlKey ||
      event.shiftKey ||
      Math.abs(event.deltaX) > Math.abs(event.deltaY) ||
      !event.deltaY
    )
      return;
    if (
      event.target.closest("textarea,input,.app-bar,pre,table,.katex-display")
    )
      return;
    for (
      let node = event.target;
      node instanceof Element && node !== document.body;
      node = node.parentElement
    ) {
      if (
        node.scrollHeight > node.clientHeight &&
        /(auto|scroll)/.test(getComputedStyle(node).overflowY)
      )
        return;
    }
    const delta =
      event.deltaY *
      (event.deltaMode === 1 ? 20 : event.deltaMode === 2 ? innerHeight : 1);
    const limit = document.documentElement.scrollHeight - innerHeight;
    if (
      limit <= 0 ||
      (scrollY <= 0 && delta < 0) ||
      (scrollY >= limit && delta > 0)
    )
      return;
    event.preventDefault();
    wheelTarget = Math.max(
      0,
      Math.min(
        (wheelFrame && (wheelTarget - scrollY) * delta > 0
          ? wheelTarget
          : scrollY) + delta,
        limit,
      ),
    );
    if (!wheelFrame) {
      wheelTime = performance.now();
      wheelFrame = requestAnimationFrame(wheelTick);
    }
  },
  { passive: false },
);
for (const event of ["pointerdown", "touchstart", "keydown", "popstate"])
  addEventListener(event, stopWheel, { passive: true });
reducedMotion.addEventListener("change", stopWheel);

// Preserve Flutter's section fades while allowing native touch and keyboard scrolling.
const sections = [...document.querySelectorAll(".fade-section")];
let fadeFrame = 0;
function updateFades() {
  fadeFrame = 0;
  for (const section of sections) {
    if (reducedMotion.matches) {
      section.style.opacity = "1";
      continue;
    }
    const rect = section.getBoundingClientRect();
    const viewport = innerHeight - 80;
    const visible = Math.max(
      0,
      Math.min(rect.bottom, innerHeight) - Math.max(rect.top, 80),
    );
    const fraction = Math.min(
      1,
      visible / (Math.min(rect.height, viewport) * 0.72),
    );
    section.style.opacity = String(fraction * fraction * (3 - 2 * fraction));
  }
}
function scheduleFades() {
  if (!fadeFrame) fadeFrame = requestAnimationFrame(updateFades);
}
if (sections.length) {
  addEventListener("scroll", scheduleFades, { passive: true });
  addEventListener("resize", scheduleFades);
  reducedMotion.addEventListener("change", scheduleFades);
  document.fonts.ready.then(scheduleFades);
  addEventListener("load", scheduleFades);
  updateFades();
}
