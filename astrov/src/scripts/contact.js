const form = document.querySelector("#contact-form");
if (form) {
  let sending = false;
  const fields = ["name", "email", "message"];
  for (const name of fields) {
    const input = form.elements[name];
    input.placeholder = " ";
    input.setAttribute("aria-describedby", `${name}-error`);
    input.addEventListener("input", () => {
      input.removeAttribute("aria-invalid");
      document.getElementById(`${name}-error`).textContent = "";
    });
  }
  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    if (sending) return;
    const values = Object.fromEntries(
      fields.map((name) => [name, form.elements[name].value.trim()]),
    );
    const errors = {
      name: values.name ? "" : "Please enter your name.",
      email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(values.email)
        ? ""
        : "Please enter a valid email address.",
      message: values.message ? "" : "Please enter a message.",
    };
    let invalid;
    for (const name of fields) {
      document.getElementById(`${name}-error`).textContent = errors[name];
      form.elements[name].setAttribute(
        "aria-invalid",
        String(Boolean(errors[name])),
      );
      if (errors[name]) invalid ||= form.elements[name];
    }
    if (invalid) {
      invalid.focus();
      return;
    }
    const status = document.querySelector("#form-status");
    const fallback = document.querySelector("#email-fallback");
    const button = form.querySelector("button[type=submit]");
    const label = button.querySelector(".send-label");
    status.hidden = true;
    fallback.hidden = true;
    sending = true;
    form.setAttribute("aria-busy", "true");
    button.disabled = true;
    fields.forEach((name) => {
      form.elements[name].disabled = true;
    });
    label.textContent = "Sending...";
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 20000);
    try {
      const response = await fetch(
        "https://formsubmit.co/ajax/nilawarush@gmail.com",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify({
            ...values,
            _replyto: values.email,
            _subject: "Portfolio contact message",
            _template: "table",
            _url: "https://nilaknaw.github.io/",
          }),
          signal: controller.signal,
        },
      );
      const result = await response.json();
      if (
        !response.ok ||
        ![true, "true"].includes(result?.success) ||
        /activat|confirm.*email/i.test(result?.message || "")
      )
        throw new Error("Submission not accepted");
      form.reset();
      status.textContent = "Message submitted. Thank you for reaching out!";
      status.classList.add("success");
    } catch {
      status.textContent =
        "Your message could not be confirmed. Please email me directly.";
      status.classList.remove("success");
      fallback.href = `mailto:nilawarush@gmail.com?subject=${encodeURIComponent("Portfolio contact")}&body=${encodeURIComponent(`${values.name}\n${values.email}\n\n${values.message}`)}`;
      fallback.hidden = false;
    } finally {
      clearTimeout(timeout);
      sending = false;
      form.removeAttribute("aria-busy");
      fields.forEach((name) => {
        form.elements[name].disabled = false;
      });
      button.disabled = false;
      label.textContent = "Send";
      status.hidden = false;
    }
  });
}
