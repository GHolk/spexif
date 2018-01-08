
const version = 'v10'

self.addEventListener('install', (installEvent) => {
    async function cacheAll() {
        const cache = await caches.open(version)
        return await cache.addAll([
            './',
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
            'ext/style.css'
        ])
    }
    console.log('start caching')
    installEvent.waitUntil(cacheAll())
    console.log('cache all file')
})

self.addEventListener('fetch', (fetchEvent) => {
    async function getResponse() {
        const cacheResponse = await caches.match(fetchEvent.request)
        if (cacheResponse) return cacheResponse
        else {
            console.log('no match cache: %s', fetchEvent.request.url)
            const newResponse = await fetch(fetchEvent.request)
            const sameOrigin = /^https?:..gholk.github.io.spexif.*$/
            if (sameOrigin.test(fetchEvent.request.url)) {
                const cache = await caches.open(version)
                await cache.put(fetchEvent.request, newResponse.clone())
            }
            return newResponse
        }
    }
    fetchEvent.respondWith(getResponse())
})

self.addEventListener('activate', (activateEvent) => {
    async function clearCache() {
        const keys = await caches.keys()
        const deleteOld = keys
            .filter((key) => key != version)
            .map((key) => caches.delete(key))
        return await Promise.all(deleteOld)
    }
    activateEvent.waitUntil(clearCache())
})
