// Retire the previously deployed Flutter worker when this site replaces Flutter.
// Keep this file at the original URL so returning browsers can update the worker.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    await Promise.all(['flutter-app-cache', 'flutter-temp-cache', 'flutter-app-manifest'].map(name => caches.delete(name)));
    await self.clients.claim();
    await self.registration.unregister();
  })());
});
