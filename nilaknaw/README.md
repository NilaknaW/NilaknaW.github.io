# nilaknaw

A new Flutter project.

Sections have their own URLs: `/`, `/projects`, and `/resources`.
The About page is disconnected; `/about` redirects to `/`.
Publications appear on Home; `/publications` redirects to `/`.
Posts and articles appear below the projects; `/blog` redirects to `/projects`.

Build with `flutter build web` and copy the contents of `build/web` to the
repository root as usual. Include `404.html`: GitHub Pages needs it to open
and refresh section URLs directly.

Contact form: messages are posted to FormSubmit's AJAX endpoint at
`https://formsubmit.co/ajax/nilawarush@gmail.com`. After deployment, submit
the form once and check that inbox (including spam) for FormSubmit's activation
email. Confirm it, then send another message to verify delivery. This replaces
the retired `formsubmit.io` integration. Automated tests use mock responses and
do not send email. See https://formsubmit.co/ajax-documentation and
https://formsubmit.co/help for setup details.
