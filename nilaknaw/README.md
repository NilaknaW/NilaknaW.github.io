# nilaknaw

A new Flutter project.

Sections have their own URLs: `/`, `/projects`, and `/resources`.
The About page is disconnected; `/about` redirects to `/`.
Publications appear on Home; `/publications` redirects to `/`.
Posts and articles appear below the projects; `/blog` redirects to `/projects`.

Build with `flutter build web` and copy the contents of `build/web` to the
repository root as usual. Include `404.html`: GitHub Pages needs it to open
and refresh section URLs directly.
