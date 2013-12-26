Overview
========

This is a collection of scripts to make downloading and building mpv, ffmpeg
and libass easier. ffmpeg and libass get special treatment, because they are
essential, and distribution packages are often too old or too broken.

See below for instructions for building Debian packages.

If you are running Mac OSX and using homebrew we provide homebrew-mpv_, an up
to date formula that compiles mpv with sensible dependencies and defaults for
OSX.

Instructions
============

Make sure git is installed. E.g. on Debian or Ubuntu:

    apt-get install git

Also check that the dependencies listed at the end of this file are
installed.

Checkout the build repo:

    git clone https://github.com/mpv-player/mpv-build.git

    cd mpv-build

Get the ffmpeg, libass and mpv sources with the following command:

    ./update

(This is always needed before doing the first build after the initial checkout,
and can be used to update ffmpeg/libass/mpv later.)

Build mpv and ffmpeg/libass with:

    ./clean                        # sometimes needed to build successfully

    ./build

Install mpv with:

    sudo ./install

mpv doesn't need to be installed. The binary ./mpv/build/mpv can be used as-is. Note
that libass and ffmpeg will be statically linked with mpv when using the
provided scripts, and no ffmpeg or libass libraries are/need to be installed.

Dependencies
============

Essential dependencies (incomplete list):

- gcc or clang, yasm, git
- X development headers (xlib, X extensions, vdpau, GL, Xv, ...)
- Audio output development headers (libasound, pulseaudio)
- fribidi, freetype, fontconfig development headers (for libass)
- libjpeg
- libquvi if you want to play Youtube videos directly
- libx264/libmp3lame/libfdk-aac if you want to use encoding (you have to
  add these options explicitly to the ffmpeg options, as ffmpeg won't
  autodetect these libraries; see next section)

Note: most dependencies are optional and autodetected. If they're missing,
these features will be disabled silently. This includes some dependencies
which could be considered essential.

Enabling optional ffmpeg dependencies
=====================================

ffmpeg doesn't autodetect many dependencies. Instead, it requires you to
enable them explicitly at configuration time. (And it will simply fail
if the dependencies are not available.)

You can put additional ffmpeg configure flags into ffmpeg_options. For
example, to enable some dependencies needed for encoding:

    echo --enable-libx264    >> ffmpeg_options

    echo --enable-libmp3lame >> ffmpeg_options

    echo --enable-libfdk-aac >> ffmpeg_options

    echo --enable-nonfree    >> ffmpeg_options

(Do this in the mpv-build toplevel directory, the same that contains
the build scripts and this readme file.)

Installing dependencies on Debian or Ubuntu
===========================================

On Debian or Ubuntu systems, you can try to run this command in the
mpv-build directory to install most of the required dependencies:

    sudo apt-get install devscripts

    mk-build-deps -s sudo -ir

This will generate and install a dummy package with the required
dependencies. (mk-build-deps is part of devscripts.)

If you don't want to use sudo, you can also try:

    mk-build-deps

    dpkg -i mpv-build-deps_1.0_all.deb

dpkg -i will require root rights of course.

Building a Debian package
=========================

You can build a full mpv Debian package with the following command:

    debuild -uc -us -b -j4

The .deb file will be created in the parent directory. (4 is the number
of jobs running in parallel - you can change it.)

Forcing master versions of all parts
====================================

The following command can be used to delete all local changes, and to checkout
the current master versions for all parts (libass, ffmpeg, mpv, as well as
mpv-build itself):

    sh ./force-head

All local modifications are overwritten (including changes to the scripts),
and git master versions are checked out. Breakages/bugs are to be expected,
because these are untested bleeding-edge development versions of the code.

Use on your own risk.

Contact
=======

You can find us on IRC in ``#mpv-player`` on ``irc.freenode.net``

Report bugs to the `issues tracker`_ provided by GitHub to send us bug
reports or feature requests.

.. _issues tracker: https://github.com/mpv-player/mpv/issues
.. _homebrew-mpv: https://github.com/mpv-player/homebrew-mpv
