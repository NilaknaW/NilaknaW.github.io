import { test, before, after } from "node:test";
import assert from "node:assert/strict";
import { chromium } from "playwright";
import { spawn } from "node:child_process";
import { readFile, readdir, mkdir, access } from "node:fs/promises";

const origin = "http://127.0.0.1:4184";
const data = JSON.parse(await readFile("src/data/site.json", "utf8"));
const projects = await Promise.all(
  (await readdir("src/content/projects")).map(async (filename) => {
    const text = await readFile(`src/content/projects/${filename}`, "utf8");
    return {
      id: filename.replace(/\.md$/, ""),
      title: JSON.parse(/^title: (.+)$/m.exec(text)[1]),
      legacyPath: /^legacyPath: (.+)$/m.test(text)
        ? JSON.parse(/^legacyPath: (.+)$/m.exec(text)[1])
        : null,
    };
  }),
);
let browser, server;

before(async () => {
  server = spawn(
    process.execPath,
    [
      "node_modules/astro/bin/astro.mjs",
      "preview",
      "--host",
      "127.0.0.1",
      "--port",
      "4184",
    ],
    {
      env: { ...process.env, ASTRO_TELEMETRY_DISABLED: "1" },
      stdio: ["ignore", "pipe", "pipe"],
    },
  );
  let output = "";
  server.stdout.on("data", (chunk) => {
    output += chunk;
  });
  server.stderr.on("data", (chunk) => {
    output += chunk;
  });
  let ready = false;
  for (let attempt = 0; attempt < 100; attempt++) {
    if (server.exitCode !== null) throw new Error(`Preview exited: ${output}`);
    try {
      ready = (await fetch(origin)).ok;
    } catch {}
    if (ready) break;
    await new Promise((resolve) => setTimeout(resolve, 200));
  }
  assert.ok(ready, `Preview did not become ready: ${output}`);
  let executablePath = process.env.BROWSER_PATH;
  if (!executablePath && process.platform === "win32") {
    const chrome = "C:/Program Files/Google/Chrome/Application/chrome.exe";
    try {
      await access(chrome);
      executablePath = chrome;
    } catch {}
  }
  browser = await chromium.launch({ executablePath, headless: true });
  await mkdir("test-results", { recursive: true });
});

after(async () => {
  await browser?.close();
  server?.kill();
});

async function open(route = "/", options = {}) {
  const context = await browser.newContext({
    viewport: { width: 1440, height: 900 },
    reducedMotion: "reduce",
    ...options,
  });
  const page = await context.newPage();
  // A test must never send an actual contact message.
  await page.route("https://formsubmit.co/**", (route) => route.abort());
  await page.goto(origin + route);
  await page.evaluate(() => document.fonts.ready);
  return page;
}

async function checkImages(page) {
  for (const image of await page.locator("img").all()) {
    if (await image.isVisible()) await image.scrollIntoViewIfNeeded();
    await image.evaluate((img) => img.decode());
  }
}

test("home retains original text, profiles, research, fonts and contact navigation", async () => {
  const page = await open();
  assert.equal(
    await page.locator("h1").textContent(),
    "I am Nilakna Warushavithana,",
  );
  assert.equal(await page.locator(".tools li").count(), 16);
  assert.equal(await page.locator(".profile-card").count(), 7);
  assert.equal(await page.locator(".research-copy a").count(), 3);
  for (const [index, profile] of data.profiles.entries()) {
    assert.equal(
      (await page.locator(".profile-card p").nth(index).innerText())
        .replace(/\s+/g, " ")
        .trim(),
      profile.description.replace(/\s+/g, " ").trim(),
    );
  }
  await checkImages(page);
  await page
    .locator(".hero")
    .getByRole("link", { name: "Contact", exact: true })
    .click();
  assert.equal(new URL(page.url()).hash, "#contact");
  await page.evaluate(() => scrollTo(0, 0));
  await page.screenshot({ path: "test-results/home-desktop.png" });
  await page.context().close();
});

test("navigation supports keyboard, touch, dismissal, and contact links across pages", async () => {
  const page = await open();
  const more = page.locator(".nav-more");
  const toggle = more.locator("summary");
  const resources = more.getByRole("link", { name: "Resources", exact: true });
  for (const width of [320, 390, 599, 600, 768, 1440]) {
    await page.setViewportSize({ width, height: 844 });
    await page.goto(origin);
    const mobile = width < 600;
    assert.equal(await page.locator(".site-name-text").isVisible(), !mobile);
    assert.equal(await page.locator(".site-icon").isVisible(), mobile);
    assert.equal(await page.locator(".more-icon").isVisible(), mobile);
    assert.equal(
      await page.locator(".desktop-nav-link:visible").count(),
      mobile ? 0 : 2,
    );
    assert.ok(await resources.isHidden());
    await toggle.focus();
    await page.keyboard.press("Enter");
    assert.ok(await resources.isVisible());
    const labels = mobile
      ? ["Projects", "Contact", "Resources"]
      : ["Resources"];
    assert.deepEqual(
      (await more.locator("a:visible").allTextContents()).map((text) => text.trim()),
      labels,
    );
    for (const label of labels) {
      await page.keyboard.press("Tab");
      assert.ok(
        await more
          .getByRole("link", { name: label, exact: true })
          .evaluate((node) => node === document.activeElement),
      );
    }
    const bounds = await resources.boundingBox();
    assert.ok(bounds.x >= 0 && bounds.x + bounds.width <= width);
    await page.keyboard.press("Escape");
    assert.ok(await resources.isHidden());
    assert.ok(await toggle.evaluate((node) => node === document.activeElement));
    await page.keyboard.press("Space");
    for (let index = 0; index <= labels.length; index++) {
      await page.keyboard.press("Tab");
    }
    assert.ok(await resources.isHidden());
    await toggle.click();
    await page.mouse.click(8, 40);
    assert.ok(await resources.isHidden());
  }
  await toggle.click();
  await resources.click();
  await page.waitForURL(origin + "/resources/");
  await page
    .locator("nav")
    .getByRole("link", { name: "Contact", exact: true })
    .click();
  await page.waitForURL(origin + "/#contact");
  assert.ok(await page.locator("#contact").isVisible());
  for (const name of ["linkedin", "orcid"]) {
    const icon = page.locator(
      `.contact-links img[src="/assets/images/${name}.svg"]`,
    );
    await icon.evaluate((img) => img.decode());
  }
  assert.equal(
    await page
      .locator(
        '.contact-links a[href="https://github.com/NilaknaW"] .icon.brand',
      )
      .count(),
    1,
  );
  await page.context().close();

  const phone = await open("/", {
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
  });
  await phone.locator(".nav-more summary").tap();
  await phone.screenshot({ path: "test-results/navigation-mobile.png" });
  await phone
    .locator(".nav-more")
    .getByRole("link", { name: "Projects", exact: true })
    .tap();
  await phone.waitForURL(origin + "/projects/");
  await phone.locator(".nav-more summary").tap();
  await phone
    .locator(".nav-more")
    .getByRole("link", { name: "Contact", exact: true })
    .tap();
  await phone.waitForURL(origin + "/#contact");
  await phone.locator(".nav-more summary").tap();
  await phone
    .locator(".nav-more")
    .getByRole("link", { name: "Resources", exact: true })
    .tap();
  await phone.waitForURL(origin + "/resources/");
  await phone.locator(".site-name").tap();
  await phone.waitForURL(origin + "/");
  await phone.locator(".nav-more summary").tap();
  await phone
    .locator(".nav-more")
    .getByRole("link", { name: "Contact", exact: true })
    .tap();
  await phone.waitForURL(origin + "/#contact");
  assert.equal(await phone.locator(".nav-more").getAttribute("open"), null);
  await phone.context().close();
});

test("all project cards and static readers work with local images, tables, and equations", async () => {
  const page = await open("/projects/");
  assert.equal(await page.locator(".project-tile").count(), projects.length);
  assert.equal(await page.locator(".award-card").count(), 8);
  await checkImages(page);
  await page.evaluate(() => scrollTo(0, 0));
  await page.screenshot({ path: "test-results/projects-desktop.png" });
  for (const project of projects) {
    await page.getByRole("link", { name: project.title, exact: true }).click();
    await page.locator("[data-reader-content]").waitFor();
    assert.equal(new URL(page.url()).pathname, `/projects/${project.id}/`);
    assert.ok((await page.title()).startsWith(project.title));
    assert.equal(
      await page.locator("link[rel=canonical]").getAttribute("href"),
      `https://nilaknaw.github.io/projects/${project.id}/`,
    );
    await checkImages(page);
    assert.equal(await page.locator(".katex-error").count(), 0);
    if (project.id === "ctsignals") {
      assert.ok((await page.locator(".katex").count()) > 20);
      assert.ok((await page.locator(".markdown table").count()) > 0);
    }
    if (project.id === "lti")
      assert.ok((await page.locator(".katex-display").count()) >= 12);
    await page.getByRole("link", { name: "All projects", exact: true }).click();
    await page.locator("#projects-grid").waitFor();
  }
  await page.context().close();
});

test("old query links, redirects, direct loads and browser history remain usable", async () => {
  const page = await open("/projects/");
  for (const project of projects.filter((p) => p.legacyPath)) {
    await page.goto(
      `${origin}/projects?project=${encodeURIComponent(project.legacyPath)}`,
    );
    await page.waitForURL(`**/projects/${project.id}/`);
    assert.ok(await page.locator("[data-reader-content]").isVisible());
  }
  await page.goto(origin + "/projects/?project=unknown");
  assert.ok(await page.locator("#projects-grid").isVisible());
  for (const [old, target] of [
    ["/blog/", "/projects/"],
    ["/about/", "/"],
    ["/publications/", "/"],
  ]) {
    await page.goto(origin + old);
    await page.waitForURL(origin + target);
  }
  await page.goto(origin + "/projects/");
  await page
    .getByRole("link", { name: "Op-amp analog IC design", exact: true })
    .click();
  await page.reload();
  assert.ok(await page.locator("[data-reader-content]").isVisible());
  await page.goBack();
  assert.ok(await page.locator("#projects-grid").isVisible());
  await page.goForward();
  assert.ok(await page.locator("[data-reader-content]").isVisible());
  await page.context().close();
});

test("resources preserve links, grouped search, consent, and password reset", async () => {
  const page = await open("/resources/");
  const show = page.getByRole("button", { name: "Agree and Show Password" });
  assert.ok(await show.isDisabled());
  await page.locator("#resource-agreement").check();
  await show.click();
  assert.equal(
    (await page.locator("#resource-password").textContent()).trim(),
    "student-resources",
  );
  assert.ok(await page.locator("#resource-password").isVisible());
  await page.locator("#resource-agreement").uncheck();
  assert.ok(await page.locator("#resource-password").isHidden());
  for (const [query, count] of [
    ["CHEMISTRY", 2],
    ["short notes", 3],
    ["Graded Exams", 1],
    ["nonexistent", 0],
    ["", 4],
  ]) {
    await page.locator("#resource-search").fill(query);
    assert.equal(await page.locator(".resource-row:visible").count(), count);
    assert.equal(
      await page.locator("#resource-count").textContent(),
      `Showing ${count} documents`,
    );
  }
  assert.deepEqual(
    await page
      .locator(".resource-row")
      .evaluateAll((rows) => rows.map((row) => row.href)),
    data.resources.map((item) => item.link),
  );
  await page.screenshot({ path: "test-results/resources-desktop.png" });
  await page.context().close();
});

test("contact validates, preserves failed messages, and only accepts confirmed success", async () => {
  const page = await open();
  const send = page.getByRole("button", { name: "Send", exact: true });
  await send.click();
  assert.equal(await page.locator("[aria-invalid=true]").count(), 3);
  await page.locator("#name").fill(" Test Name ");
  await page.locator("#email").fill("test@example.com");
  await page.locator("#message").fill("A test message");
  await send.click();
  await page.locator("#email-fallback").waitFor({ state: "visible" });
  assert.equal(await page.locator("#message").inputValue(), "A test message");
  await page.route("https://formsubmit.co/**", (route) =>
    route.fulfill({
      status: 200,
      contentType: "application/json",
      body: JSON.stringify({
        success: "true",
        message: "Please activate your form",
      }),
    }),
  );
  await send.click();
  await page.locator("#email-fallback").waitFor({ state: "visible" });
  assert.equal(await page.locator("#message").inputValue(), "A test message");
  await page.route("https://formsubmit.co/**", async (route) => {
    const payload = route.request().postDataJSON();
    assert.equal(payload.name, "Test Name");
    assert.equal(payload._replyto, "test@example.com");
    await route.fulfill({
      status: 200,
      contentType: "application/json",
      body: JSON.stringify({ success: true, message: "Message delivered" }),
    });
  });
  await send.click();
  await page.locator("#form-status.success").waitFor();
  assert.equal(await page.locator("#message").inputValue(), "");
  assert.ok(await page.locator("#email-fallback").isHidden());
  await page.context().close();
});

test("phone, tablet, desktop and reader layouts fit the screen with no script errors", async () => {
  const page = await open();
  const errors = [];
  page.on("pageerror", (error) => errors.push(error.message));
  for (const width of [320, 390, 768, 1024, 1440]) {
    await page.setViewportSize({ width, height: 844 });
    for (const route of [
      "/",
      "/projects/",
      "/resources/",
      "/projects/ctsignals/",
    ]) {
      await page.goto(origin + route);
      await page.evaluate(() => document.fonts.ready);
      assert.ok(
        await page.evaluate(
          () => document.documentElement.scrollWidth <= innerWidth + 1,
        ),
        `Overflow at ${route}, ${width}px`,
      );
      if (width === 390)
        await page.screenshot({
          path: `test-results/mobile-${route.replaceAll("/", "-") || "home"}.png`,
        });
    }
  }
  assert.deepEqual(errors, []);
  await page.context().close();
});

test("readers and page content are available without JavaScript", async () => {
  const page = await open("/", {
    javaScriptEnabled: false,
    viewport: { width: 390, height: 844 },
  });
  assert.equal(await page.locator(".profile-card").count(), 7);
  await page.locator(".nav-more summary").click();
  await page
    .locator(".nav-more")
    .getByRole("link", { name: "Resources" })
    .click();
  await page.waitForURL(origin + "/resources/");
  await page.goto(origin + "/projects/");
  await page
    .getByRole("link", { name: "Op-amp analog IC design", exact: true })
    .click();
  assert.ok(await page.locator("[data-reader-content]").isVisible());
  await page.goto(origin + "/resources/");
  assert.equal(await page.locator(".resource-row").count(), 4);
  await page.context().close();
});
