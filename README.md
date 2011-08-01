# Gentoo Overlay for Tinyos 2.x

## Overview

This is a Gentoo Overlay for TinyOS 2.x.

As of mid-2011, this overlay seems to be working. The user can execute
`emerge -avt tinyos` (after adding the relevant entries to
`/etc/portage/package.keywords`), and portage will be able to install 7 ebuilds
without failure. It is also possible to run `make micaz` inside *Blink* example
app.

However, this overlay needs a maintainer. Do you work with TinyOS and want to
help? Feel free to fork this project!

## Further improvements

Wanna help and don't know how to start? Here are some suggestions:

* Make sure all ebuilds are updated to the latest portage changes. In other
  words, make sure portage won't complain about errors or outdated features.
* Make sure all packages are correctly installed and ready-to-use. (requires
  knowing how to use each package)
* Add an ebuild for TOSSIM simulator, or install it from `tos-sdk-python`. (so
  that `import TOSSIM` works, inside Python)
* Clean up old outdated ebuilds that are not relevant anymore.

## History

This overlay was originally created by Aurelien Francillon (aurelf) in late
2006, and later had contributions from Sandro Bonazzola (sandrobonazzola) in
2008. Since then, the contributions have halted, as both authors have moved on
to other projects.

In 2011, about 2 years later, Denilson Sá (denilsonsa) tried to use this
overlay but couldn't, as it became broken due the lack of maintenance. He did
some efforts to fix/update the ebuilds and move the overlay from a self-hosted
SVN to GitHub, but later had to stop, as he also moved on to other projects.

This overlay in GitHub is an invitation to contributions! None of the previous
authors can work on this overlay anymore. If need TinyOS on Gentoo, feel free
to fork this project and update it!

## Links

* Documentation used to be available at: http://gentoo-wiki.com/TinyOS (there
  is a mirror at http://naurel.org/stuff/gentoo_howto_tinyos.html , and also a
  local copy at the *various/* directory of this repository)
* Previous self-hosted SVN repository was available at:
  https://naurel.org/svn/tinyos-2-overlay/
* TinyOS homepage: http://www.tinyos.net/ (a bit outdated, though)
* TinyOS project page: http://code.google.com/p/tinyos-main/ (very active)

## Old README information (that might be outdated)

You can find packages.keywords in various/

msp430 support is limited at this time:
merge crossdev from this overlay
use
FEATURES="-sandbox nostrip " crossdev -t msp430


 TODO:

++ Classpath modification by eselect-tinyos is broken
++ Modify eselect tinyos in order to change class path and makerules
+ Clarify which package should be dropped / which should be kept

x  split tos ebuild
 into
       tos-2.0.0.ebuild
       tos-sdk-c-2.0.0.ebuild
       tos-sdk-java-2.0.0.ebuild
       tos-sdk-python-2.0.0.ebuild

+ fix the rependency

BUGS:
+ toolchain:
	msp : 207284
	avr: 147155


emerge tinyos fetches :

\=dev-tinyos/tinyos-2.0.2  \=dev-tinyos/tos-sdk-python-2.0.2 \=dev-tinyos/tos-sdk-java-2.0.2 \=dev-tinyos/tos-sdk-c-2.0.2  \=dev-tinyos/tinyos-tools-1.2.4 \=dev-tinyos/nesc-1.2.9 \=dev-tinyos/tos-2.0.2 \=dev-tinyos/tinyos-docs-2.0.2 \=dev-python/docutils-0.4-r3 app-emacs/rst-0.4-r1 virtual/jre-1.6.0 virtual/jdk-1.6.0 \=dev-java/sun-jdk-1.6.0.07 \=dev-java/java-sdk-docs-1.6.0-r1 \=dev-tinyos/eselect-tinyos-0.2

