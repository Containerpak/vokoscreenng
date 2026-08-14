FROM ghcr.io/containerpak/mesa64-sdk:main AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG VOKOSCREEN_URL=https://github.com/vkohaupt/vokoscreenNG/archive/f851473514be1054da70e037fce528b8e681f158.tar.gz
ARG VOKOSCREEN_SHA256=48bada1e629832f241fa93bfb499ec0980a4a51234facdbc19c4b5afa5e283de

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl libglib2.0-dev libgstreamer-plugins-base1.0-dev \
    libgstreamer1.0-dev libpulse-dev libwayland-dev libx11-dev make \
    qt6-base-dev qt6-base-dev-tools qt6-multimedia-dev qt6-tools-dev-tools && \
    curl -fL "$VOKOSCREEN_URL" -o /tmp/vokoscreen.tar.gz && \
    echo "$VOKOSCREEN_SHA256  /tmp/vokoscreen.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/vokoscreen && \
    tar -xzf /tmp/vokoscreen.tar.gz -C /tmp/vokoscreen --strip-components=1 && \
    cd /tmp/vokoscreen/src && \
    qmake6 vokoscreenNG.pro && \
    make -j"$(nproc)" && \
    install -Dm755 vokoscreenNG /out/usr/bin/vokoscreenNG && \
    install -Dm644 applications/vokoscreenNG.desktop \
    /out/usr/share/applications/vokoscreenNG.desktop && \
    install -Dm644 applications/vokoscreenNG.png \
    /out/usr/share/icons/hicolor/256x256/apps/vokoscreenNG.png

FROM ghcr.io/containerpak/mesa64:main

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=build /out/usr/ /usr/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg gstreamer1.0-libav gstreamer1.0-plugins-bad \
    gstreamer1.0-pipewire gstreamer1.0-plugins-good gstreamer1.0-pulseaudio \
    intel-media-va-driver libpulse0 libqt6dbus6 libqt6multimedia6 \
    libqt6network6 libqt6widgets6 libwayland-client0 libx11-6 \
    pipewire qt6-qpa-plugins && \
    cpak-clean-junk
