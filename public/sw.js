// Regal Trip service worker — makes the app installable and usable offline
// (handy for no-signal spots like the Redwoods).
const CACHE = 'regal-trip-v3';
const SHELL = [
  '/', '/index.html', '/print.html', '/manifest.webmanifest',
  '/icon-192.png', '/icon-512.png', '/favicon.ico', '/favicon-32.png',
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE)
      .then((c) => c.addAll(SHELL)
        // Warm the trip data too, so a freshly installed app is usable even if
        // it goes offline before the first manual refresh. Non-fatal if it fails.
        .then(() => c.add('/api/state').catch(() => {})))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return; // never touch writes (bookings/chat)
  const url = new URL(req.url);

  // Trip state: network-first, fall back to the last cached copy when offline.
  if (url.pathname === '/api/state') {
    e.respondWith(
      fetch(req)
        .then((res) => { const c = res.clone(); caches.open(CACHE).then((cc) => cc.put(req, c)); return res; })
        .catch(() => caches.match(req))
    );
    return;
  }

  // Other API calls (chat/history): just try the network.
  if (url.pathname.startsWith('/api/')) {
    e.respondWith(fetch(req).catch(() => caches.match(req)));
    return;
  }

  // HTML pages: network-first, so app/code updates always appear when online;
  // fall back to the cached copy (or the app shell) when offline.
  if (req.mode === 'navigate' || (req.headers.get('accept') || '').includes('text/html')) {
    e.respondWith(
      fetch(req)
        .then((res) => { const c = res.clone(); caches.open(CACHE).then((cc) => cc.put(req, c)); return res; })
        .catch(() => caches.match(req).then((h) => h || caches.match('/index.html')))
    );
    return;
  }

  // Static assets (icons, manifest): cache-first for speed and offline use.
  e.respondWith(
    caches.match(req).then((hit) =>
      hit || fetch(req)
        .then((res) => { const c = res.clone(); caches.open(CACHE).then((cc) => cc.put(req, c)); return res; })
        .catch(() => hit)
    )
  );
});
