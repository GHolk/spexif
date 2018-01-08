
const version = 'v1'

self.addEventListener('install', async (installEvent) => {
    const cache = await caches.open(version)
    const cacheAll = cache.addAll([
        './',
        'index.html',
        'doc/report.html',
        'ext/cacheImage.js',
        'ext/domHelper.js',
        'ext/errorSpeaker.js',
        'ext/filterPiexif.js',
        'ext/googleMapWraper.js',
        'ext/icon144.png',
        'ext/icon48.png',
        'ext/imageList.js',
        'ext/inputFile.js',
        'ext/leafletMapWraper.js',
        'ext/manifest.json',
        'ext/mobile.css',
        'ext/piexif.js',
        'ext/service-worker.js',
        'ext/style.css'
    ])
    console.log('cache all file')
    installEvent.waitUntil(cacheAll)
})

self.addEventListener('fetch', async (fetchEvent) => {
    const cacheResponse = await caches.match(fetchEvent.request)
    if (cacheResponse) {
        console.log('match cache: %s', fetchEvent.request)
        fetchEvent.respondWith(cacheResponse)
    }
    else {
        console.log('no match cache: %s', fetchEvent.request)
        const newResponse = await fetch(fetchEvent.request)
        const cache = await caches.open(version)
        cache.put(fetchEvent.request, newResponse.clone())
        fetchEvent.respondWith(newResponse)
    }
})

