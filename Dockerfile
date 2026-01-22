FROM alpine:3.23

LABEL org.opencontainers.image.authors="Felix Buenemann <felix.buenemann@gmail.com>"

ARG VIPS_VERSION=8.18.0
RUN set -x -o pipefail \
    && wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz | tar xJC /tmp \
    && apk update \
    && apk upgrade \
    && apk add \
    zlib libxml2 glib gobject-introspection \
    libjpeg-turbo libexif lcms2 fftw cgif libpng \
    libwebp libwebpmux libwebpdemux highway tiff poppler-glib librsvg libarchive openexr-libopenexr \
    libheif libimagequant libjxl pango \
    && apk add --virtual vips-dependencies build-base meson ninja \
    zlib-dev libxml2-dev glib-dev gobject-introspection-dev \
    libjpeg-turbo-dev libexif-dev lcms2-dev fftw-dev cgif-dev libpng-dev \
    libwebp-dev highway-dev tiff-dev poppler-dev librsvg-dev libarchive-dev openexr-dev \
    libheif-dev libimagequant-dev libjxl-dev pango-dev \
    py-gobject3-dev \
    && meson setup /tmp/vips-${VIPS_VERSION}/build /tmp/vips-${VIPS_VERSION} --prefix /usr --buildtype release \
    -Dheif-module=disabled -Dpoppler-module=disabled -Djpeg-xl-module=disabled \
    && meson compile -C /tmp/vips-${VIPS_VERSION}/build \
    && meson install -C /tmp/vips-${VIPS_VERSION}/build --strip \
    && rm -rf /tmp/vips-${VIPS_VERSION} \
    && apk del --purge vips-dependencies \
    && rm -rf /var/cache/apk/*
