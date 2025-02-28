Overview
========

This is a collection of scripts to make downloading and building mpv, ffmpeg
and libass easier. ffmpeg and libass get special treatment, because they are
essential, and distribution packages are often too old or too broken.

Generic Instructions
====================

Make sure git is installed. Also check that the dependencies listed in
the next section are installed.

Checkout the build repo::

    git clone https://github.com/mpv-player/mpv-build.git

    cd mpv-build

To get the ffmpeg, libass and mpv sources and build them, run the command::

    ./rebuild -j4

The ``-j4`` asks it to use 4 parallel processes.

Note that this command implicitly does an update followed by a full cleanup
(even if nothing changes), which is supposed to reduce possible problems with
incremental builds. You can do incremental builds by explicitly calling
``./build``. This can be faster on minor updates, but breaks sometimes, e.g.
the FFmpeg build system can sometimes be a bit glitchy.

Install mpv with::

    sudo ./install

mpv doesn't need to be installed. The binary ./mpv/build/mpv can be used as-is.
You can copy it to /usr/local/bin manually. Note that libass and ffmpeg will be
statically linked with mpv when using the provided scripts, and no ffmpeg or
libass libraries are/need to be installed. There are no required config or
data files either.

**Note**: If you are on debian, you may need to install meson from backports
in order to get a non-ancient version. Alternatively, you can install it from
PyPi.

Dependencies
============

Essential dependencies (incomplete list):

- gcc or clang, yasm, git, meson, ninja
- autoconf/autotools (for libass)
- X development headers (xlib, X extensions, vdpau, GL, Xv, ...)
- Audio output development headers (libasound, pulseaudio)
- fribidi, freetype, fontconfig, harfbuzz development headers (for libass)
- libjpeg
- OpenSSL or GnuTLS development headers if you want to open https links
  (this is also needed to make youtube-dl interaction work)
- youtube-dl (at runtime) if you want to play Youtube videos directly
  (a builtin mpv script will call it)
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
example, to enable some dependencies needed for encoding::

    printf "%s\n" --enable-libx264    >> ffmpeg_options

    printf "%s\n" --enable-libmp3lame >> ffmpeg_options

    printf "%s\n" --enable-libfdk-aac >> ffmpeg_options

    printf "%s\n" --enable-nonfree    >> ffmpeg_options

Do this in the mpv-build top-level directory (the same that contains
the build scripts and this readme file). It must be done prior running
./build or ./rebuild.

NAME_options files (where NAME is ffmpeg/mpv/libass/fribidi)
============================================================

These files can hold custom configure options which are passed to the
respective configure scripts.

Empty lines are ignored, and every non-empty line becomes a single verbatim
argument (including leading and/or trailing spaces) when invoking the
respective configure script.

This means that shell quotes should *not* be placed at these files, and the
values should not be indented.

The files can hold arbitrary values, except empty values and values which
contain newline[s].

Except empty/with-newlines, any list of configure arguments, for instance::

    ./configure   --thing=foo --libs="-L/bar -lbaz" -x abc +z

can also be added to the file, like so::

    printf "%s\n" --thing=foo --libs="-L/bar -lbaz" -x abc +z >> ffmpeg_options

Instructions for Debian / Ubuntu package
========================================

Run ``./update`` first. Note that the NAME_options files are respected - but may
conflict with the built-in Debian build options. For best results one should
customize the build only via the files ``debian/rules`` and ``debian/control``.

To help track dependencies and installed files, there is the option to create a
Debian package containing the mpv binary and documentation. This is considered
advanced usage and you may experience problems if you have weird third party
repositories enabled or use exotic Debian derivatives. This procedure is
regularly tested on Debian Sid.

Install some basic packaging tools with the command::

    apt-get install devscripts equivs

In the mpv-build root directory, create and install a dummy build dependency
package::

    mk-build-deps -s sudo -i

You can now build the mpv Debian package with the following command::

    dpkg-buildpackage -uc -us -b -j4

Adjust the "4" to your number of available processors as appropriate. On
completion, the file mpv_<version>_<architecture>.deb will be created in the
parent directory. Install it with::

    sudo dpkg -i ../mpv_<version>_<architecture>.deb

where you must replace <version> with the version of mpv you just built (as
indicated in debian/changelog) and <architecture> with your architecture.

To keep your package up to date, simply repeat the above commands after running
the ``./update`` script in the mpv-build root directory from time to time.

Local changes to the git repositories
=====================================

Making local changes to the created git repositories is generally discouraged.
Updating might remove local changes or conflict with them. Sometimes the
repositories might be wiped entirely. If you make local changes, always keep
them in a separate repository and merge them after updating.

In general, changes to the mpv-build repository itself are relatively safe,
keeping branches in sub-repositories might be ok, and making local, uncommitted
changes in sub-repositories will break.

Selecting release vs. master versions
=====================================

By default, mpv, ffmpeg, libplacebo and libass use the git master versions.
These are bleeding edge, but should usually work fine. To get a stable
(slightly stale) version, you can use release versions.
Note that at least for mpv, releases are not actually maintained - releases
are for Linux distributions, which are expected to maintain them and to
backport bug fixes (which they usually fail to do).

The following command can be used to delete all local changes, and to checkout
the latest release version of mpv::

    ./use-mpv-release

And run ``./rebuild`` or similar. Use this to switch back to git master::

    ./use-mpv-master

Or this to switch to a custom tag/branch/commit FOO::

    ./use-mpv-custom FOO

Likewise, you can use ``./use-ffmpeg-master``, ``./use-ffmpeg-release`` or
``./use-ffmpeg-custom BAR`` to switch between git master, the latest FFmpeg
release, or to a custom tag/branch/commit BAR.

Use on your own risk.

mpv configure options
=====================

Just like ``ffmpeg_options``, the file ``mpv_options`` in the
mpv-build top-level directory can be used to set custom mpv configure
options prior to compiling. Like with ffmpeg_option, it expects one
switch per line (e.g. ``-Dsomething=enabled``).

But normally, you shouldn't need this.

Building libmpv
---------------

libmpv is built by default, but you can disable it in the configure option::

    printf "%s\n" -Dlibmpv=false > mpv_options

The Debian packaging scripts do not currently support libmpv.

Contact
=======

You can find us on IRC in ``#mpv`` on ``irc.libera.chat``

Report bugs to the `issues tracker`_ provided by GitHub to send us bug
reports or feature requests.

.. _issues tracker: https://github.com/mpv-player/mpv/issues
