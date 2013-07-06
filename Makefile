mpv: ffmpeg libass
	scripts/mpv-config
	$(MAKE) -C mpv

mpv-config:
	scripts/mpv-config

ffmpeg-config:
	scripts/ffmpeg-config

ffmpeg: ffmpeg-config
	$(MAKE) -C ffmpeg_build install

fribidi-config:
	scripts/fribidi-config

fribidi: fribidi-config
	$(MAKE) -C fribidi install

libass-config: fribidi
	scripts/libass-config

libass: libass-config
	$(MAKE) -C libass install

noconfig:
	$(MAKE) -C ffmpeg_build install
	$(MAKE) -C fribidi install
	$(MAKE) -C libass install
	$(MAKE) -C mpv

install:
	$(MAKE) -C mpv install

clean:
	-rm -rf ffmpeg_build build_libs
	-$(MAKE) -C fribidi distclean
	-$(MAKE) -C libass distclean
	-$(MAKE) -C mpv distclean

.PHONY: mpv-config mpv ffmpeg-config ffmpeg fribidi-config fribidi libass-config libass noconfig install clean
