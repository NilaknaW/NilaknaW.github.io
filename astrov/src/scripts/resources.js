const agreement = document.querySelector("#resource-agreement");
if (agreement) {
  const show = document.querySelector("#show-password");
  const password = document.querySelector("#resource-password");
  agreement.addEventListener("change", () => {
    show.disabled = !agreement.checked;
    if (!agreement.checked) password.hidden = true;
  });
  show.addEventListener("click", () => {
    if (agreement.checked) password.hidden = false;
  });
  document
    .querySelector("#resource-search")
    .addEventListener("input", (event) => {
      const query = event.target.value.trim().toLowerCase();
      let count = 0;
      document.querySelectorAll(".resource-row").forEach((row) => {
        row.hidden = !row.dataset.search.includes(query);
        if (!row.hidden) count++;
      });
      document.querySelectorAll(".resource-group").forEach((group) => {
        group.hidden = !group.querySelector(".resource-row:not([hidden])");
      });
      document.querySelector("#resource-count").textContent =
        `Showing ${count} documents`;
      document.querySelector("#resource-empty").hidden = count > 0;
    });
}
