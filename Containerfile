FROM ghcr.io/containerpak/gtk:main

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gstreamer1.0-libav gstreamer1.0-pulseaudio intel-media-va-driver \
    vokoscreen-ng && \
    cpak-clean-junk
