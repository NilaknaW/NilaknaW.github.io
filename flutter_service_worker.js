'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "00d213090218b072845a433ddead4427",
"assets/AssetManifest.bin.json": "f53f68c4229645765dc1a949095e6789",
"assets/AssetManifest.json": "8015968391bac9dcaf94d1d83c754e04",
"assets/assets/images/favicon.png": "f41a7b4ee2999c0ccdcaf0aeb0fc00bc",
"assets/assets/images/hockey.jpeg": "c6c4f61b56b3ceaac1d76d6567f07129",
"assets/assets/images/Icon-192.png": "070b5ed3f42faef4ddaded59b50c2dce",
"assets/assets/images/linkedin.svg": "7e594f78039ba4c22666cafc5fe167ab",
"assets/assets/images/music.jpeg": "19fd42222f2a798e1e66ef835233bea8",
"assets/assets/images/music4.jpeg": "d56e32c493309b45b064de993e353241",
"assets/assets/images/profile.jpeg": "0ce55485764fd029d6813f7d498206a0",
"assets/assets/images/school.JPG": "34712ebbf249eb4afeef1dd057633752",
"assets/assets/images/uom.jpeg": "a20b026073c3b630f97ad082ebc51565",
"assets/assets/markdown/alpr.jpeg": "d23394a9d986f7f2a919171f0a68a054",
"assets/assets/markdown/alpr.md": "5ff24419918a8988d5dd695c5c8d3089",
"assets/assets/markdown/careerf.md": "d8632e1d29e122e890e15865db9d19a3",
"assets/assets/markdown/careerf.png": "a1b249931d1cad9566745e2bc6239cbb",
"assets/assets/markdown/ctsignal/ctsignals.md": "1c30b7d006d6a61b5fc330f364af92ac",
"assets/assets/markdown/ctsignal/res/ft-1.png": "2ab36e9b75c4783376cc2ef6f7215550",
"assets/assets/markdown/ctsignal/res/lt-1.png": "8eead6f3150bd36c21a69633276fe521",
"assets/assets/markdown/ctsignal/res/lt-2.png": "0ca820c445fe2c6c9d7218da18b3603d",
"assets/assets/markdown/ctsignal/res/winding-1.jpeg": "794587daa1c497004b65f7bc29ab5e2b",
"assets/assets/markdown/ctsignal/res/winding-peak.jpeg": "83f9971959ae8c14faa70a48a058f4bf",
"assets/assets/markdown/ctsignal/res/winding-pk-2.jpeg": "8d1817f2ca599a6b4dda3c22d4d08183",
"assets/assets/markdown/ctsignal/res/winding-samples.jpeg": "0e15ddfb46690f1ab9870e2c5c8d49b3",
"assets/assets/markdown/ctsignal/res/xt-1.png": "dd19dbab8221ea5efdf3e14886861d21",
"assets/assets/markdown/ctsignal/res/xt-2.png": "73a13ff85b3c5459d1329a744e6a0924",
"assets/assets/markdown/glycoiq.md": "db30d69caf72dff59d4f8c1f290fd49d",
"assets/assets/markdown/glycoiq.png": "0ea691da32515ccc7cb20679615d8f30",
"assets/assets/markdown/glycoiq2.jpeg": "590c3a6c54772cacc5c091dec1a2ac7d",
"assets/assets/markdown/glycoiq3.png": "ef0de209b13d7a8ae0315122abae85ae",
"assets/assets/markdown/image.png": "a1b249931d1cad9566745e2bc6239cbb",
"assets/assets/markdown/lti/lti.md": "76b43d83cbb80048107c51c67b98a802",
"assets/assets/markdown/makeathon8.jpeg": "6656750bc1045adde8f363644022c450",
"assets/assets/markdown/npu/5583.jpg": "fcdb3af2844bc4632fd9afc23a86bc41",
"assets/assets/markdown/npu/npu.md": "d37342d89274ffc7ed047802c065bfc9",
"assets/assets/markdown/nutri.md": "1a02e5ba431f1c94ae1542a7dc55f937",
"assets/assets/markdown/nutri.png": "670e47ece40c75edc0e6dc86360bdeea",
"assets/assets/markdown/nutri1.jpeg": "e1dd24a38079417fee86d0cd4bd2733b",
"assets/assets/markdown/siliconedge/siliconedge.md": "1c91952786e9259f52717b3e6963cfac",
"assets/assets/markdown/siliconedge/sp1.jpeg": "9d31c9a1c1b7853772ed72621ef4a131",
"assets/assets/markdown/siliconedge/sp4.jpeg": "e74043689d1e7a52668785356b5f771e",
"assets/assets/markdown/siliconedge/sp5.jpeg": "e6ca24a3a89e89f7875d23fd5c807053",
"assets/assets/markdown/siliconedge/sp6.jpeg": "a71098c9374fda06bc2554b38127698b",
"assets/assets/markdown/siliconedge/sp7.jpeg": "90f963237e1162c612e1275b1ff6d0b5",
"assets/assets/markdown/smartglow.jpeg": "eb4cd61d0a47a003b79615a06f6323e0",
"assets/assets/markdown/smartglow.md": "49215cecdb0911be9510fa5af6dbc0c3",
"assets/assets/markdown/transmit.jpeg": "a06fc6cd4e2d5eb441013b28507e7a26",
"assets/assets/markdown/transmit.md": "d978a4cf886d8c7824722a4642aba301",
"assets/assets/markdown/wwf.md": "ba9f4b32b202e24e4e8823152f568ea4",
"assets/assets/markdown/wwf.png": "3ec638cbd5d8450a5ac1c2cfde61fae1",
"assets/FontManifest.json": "715399a9aadecc9767cf4b35139e3368",
"assets/fonts/MaterialIcons-Regular.otf": "4f7c54afdefbd62e2e9bb8e69153793a",
"assets/NOTICES": "be59b5080e9cb997a4ae3aa44a093891",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/simple_icons/fonts/SimpleIcons.ttf": "90580190a5349ea2d3a73ccca4c41e4a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "f41a7b4ee2999c0ccdcaf0aeb0fc00bc",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "a97352ded7f763e19c6910a21dd849a7",
"icons/Icon-192.png": "070b5ed3f42faef4ddaded59b50c2dce",
"icons/Icon-512.png": "d4740324c7b27640542fdfe0814efaf3",
"icons/Icon-maskable-192.png": "070b5ed3f42faef4ddaded59b50c2dce",
"icons/Icon-maskable-512.png": "d4740324c7b27640542fdfe0814efaf3",
"index.html": "55b267f4690b87cbdae7aa091bc821c4",
"/": "55b267f4690b87cbdae7aa091bc821c4",
"main.dart.js": "eae6ba1a6b0d1e443213c3cc2b8f5b9e",
"manifest.json": "5c18f057557870652a46253e946e8820",
"version.json": "51664be4f5202cd3462ed56cacf7fc55"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
