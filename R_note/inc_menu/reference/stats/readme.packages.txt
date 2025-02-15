Building from a source-code library under Windows
=================================================

[If you are reading this file as part of the full R source distribution,
you need to build R first: see file INSTALL.]


    *** This file contains a lot of prescriptive comments.  They are
    here as a result of bitter experience.  Please do not report problems
    to R-help unless you have followed all the prescriptions. ***


If your package has no C nor Fortran nor C++ sources, see `Simple ports' 
near the bottom of this file.

First collect the tools that you need.  There is a `portal' with
current links at http://www.stats.ox.ac.uk/pub/Rtools/.


You will need suitable versions of at least make, sh, cat, cp, diff,
echo, mkdir, mv, rm, sed; we have packaged a set at
http://www.stats.ox.ac.uk/pub/Rtools/tools.zip extracted from the
cygwin distribution (http://www.cygwin.com/mirrors.html) or (gzip)
compiled from the sources.


BEWARE: `Native' ports of make are _not_ suitable (including that at
the mingw site).  There were also problems with several earlier
versions of the cygwin tools and dll.  To avoid frustration, please
use our tool set, and make sure it is at the front of your path.

We recommend that you use a recent snapshot of the Mingw port of gcc
from http://sourceforge.net/projects/mingw/. There will probably
be a distribution called something like MinGW-2.0.0-2.exe, or you can
get the components (binutils-2.13, gcc-3.2, mingw-runtime-2.2 and
w32api-2.0 or later.)  Earlier versions will probably work, but
mingw-runtime >= 1.3 and w32api >= 1.5 are highly desirable.

No earlier Mingw compiler has been tested and support for using the
Cygwin compiler has been withdrawn.  If you see errors about `-shared'
not being understood or `__imp_foo' missing, you are not using the
recommended compiler.


The Windows port of perl5, available via
http://www.activestate.com/Products/ActivePerl/.
BEWARE: you do need the *Windows* port and not the Cygwin one.


If you want to make compiled html (.chm) files you will need the
Microsoft HTML Help Workshop, currently available for download at
http://msdn.microsoft.com/library/en-us/htmlhelp/html/hwmicrosofthtmlhelpdownloads.asp
and http://www.microsoft.com/office/ork/xp/appndx/appa06.htm

You may need this on the same drive as the other tools. (Although we
have successfully used it elsewhere, others have reported problems).


For large packages it is helpful to make zipped help and/or data
files: for that you need zip and unzip from the Info-ZIP project
(www.info-zip.org and mirrors, and included in our tools.zip).


All of these need to be installed and in your path, and the
appropriate environment variables set.  
Edit MkRules to set the appropriate paths as needed.
BEWARE: MkRules contains tabs and some editors (e.g. WinEdt) silently 
remove them.

Do not use paths with spaces in: you can always use the short forms.
Do not use unnecessary quotes in your PATH variable.
Do not have our toolset and any other version of cygwin1.dll in your path.


BEWARE: if you have Norton Anti-Virus you may need to disable it.
Some versions lock up the machine when windres is run.  (Norton
Anti-Virus 2002 causes no problems.)

BEWARE: Don't expect this to work if the path to R_HOME contains spaces.
As from R 1.5.0 it may work, but we don't recommend it.

Then

	cd R_HOME\src\gnuwin32
	make libR.a libRblas.a

which might take up to a minute.  This only needs to be done once for
each R release, and will be done automatically when needed if
omitted at this point.


At this point there are two approaches:

1) Streamlined way

Assuming that ...\rw1050\bin is in your path, use

	Rcmd INSTALL package

where `package' can be a directory or a .tar.gz file.  See
Rcmd INSTALL --help for a full list of options, which include

  -l, --library=LIB	install packages to library tree LIB
      --docs=TYPE	type(s) of documentation to build and install
      --use-zip-data	collect data files in zip archive
      --use-zip-help	collect help and examples into zip archives
      --use-zip		combine `--use-zip-data' and `--use-zip-help'

TYPE can be "none" or "normal" or "chm" (the default) or "winhlp" or "all"


2) Manual `full-control'

For each package you want to install, unpack it to a directory, say
mypkg, in R_HOME\src\library, and run

	cd R_HOME\src\gnuwin32
	make pkg-mypkg


Customising compilation
=======================

The Makefiles can be customized: in particular the name of the DLL can
be set (for example we once needed integrate-DLLNM=adapt), the compile
flags can be set (see the examples in MakeDll) and the types of help
(if any) to be generated can be chosen (variables HELP and WINHELP).
The simplest way to customize the compilation steps is to set variables in
a file src\Makevars.win, which will automatically be included by MakeDLL.
For example, for RODBC src\Makevars.win could include the line

DLLLIBS+=-lodbc32

or, equivalently,

RODBC-DLLLIBS=-lodbc32

If you have a file src\Makefile.win, that will be used as the makefile
for source compilation in place of our makefile MakeDll.

BEWARE: files src\Makefile or src\Makevars will be used if they exist
and the .win equivalents do not.  Such files included in package
sources are usually designed for use under Unix and are best removed.

BEWARE: references to variables in R.dll are converted to the
right form by using the header files.  You must include them.


Using zipped help files
=======================

You will need zip installed, of course. Just run

	make ziponly-mypkg

after building mypkg.  Target `ziphelp-mypkg' will make the zip files
but not remove the separate files: this can be used for testing.

This is an option to Rcmd INSTALL.


Using zipped data files
=======================

You will need zip installed. Just run

	make zipdata-mypkg

after building mypkg.  This is recommended if you have either many small
data files (as in package Devore5) or a few large data files.

This is an option to Rcmd INSTALL.


Checking and building packages
==============================

The equivalent of `R CMD check mypkg' on Unix is

	Rcmd check mypkg

Use `Rcmd check --help' for full details.  There is an analogous call for
build.

You may need to set TMPDIR to (the absolute path to) a suitable
temporary directory: the default is c:/TEMP.  (Use forward slashes,
although the code will try to convert backslashes as from 1.7.0.)

These have been used successfully under NT/2000/XP.  We have seen
problems with some Perl versions on Win 95/98/ME, but believe these
are now resolved.  make pkgcheck-mypkg will perform the tests of the
examples and tests directory, as far as we know on all versions of Windows.


Debugging
=========

See the rw-FAQ.


Using Visual C++
================

You may if you prefer use Visual C++ to make the DLLs (unless they use
Fortran source!). First build the import library R.lib by

	lib /def:R.exp /out:Rdll.lib

Then you can compile the objects and build the DLL by

	cl /MT /Ox /D "WIN32"  /c *.c
	link /dll /def:mypkg.def /out:mypkg.dll *.obj Rdll.lib

where you will need to create the .def file by hand listing the entry
points to be exported.  (If there are just a few you can use /export
flags instead.) If the C sources use R header files you will need to
arrange for these to be searched, perhaps by including in the cl line

	/I ..\..\..\include

If you build a debug version of the DLL in the development
environment, you can debug the DLL code there just by setting the
executable to be debugged as the full path to the R front-end.

Extra care is needed when referencing variables (rather than
functions) exported from R.dll.  These must be declared
__declspec(dllimport) (as in R's own header files).  A list of the
relevant variables is in the file `exported-vars'.


Using Borland C++
=================

Borland C++5.5 is available as a free download from
http://www.borland.com/bcppbuilder/freecompiler/ and as part of C++
Builder 5.  The following will make convolve.dll from convolve.c (flag
-6 optimizes for a Pentium Pro/II/III/4, and -u- removes extra underscores)

bcc32 -u- -6 -O2 -WDE convolve.c

You can build an import library for R.dll by copying R.exp to R.def and
using

implib R.lib R.def

and then add R.lib to the bcc32 command line, for example (from
Venables & Ripley's `S Programming')

bcc32 -u- -6 -O2 -WDE -I\R\rw1050\src\include VCrndR.c R.lib

We believe that when referencing variables (rather than functions)
exported from R.dll these must be declared __declspec(dllimport) just
as for VC++.


Using other compilers and languages
===================================

To use C++ see the section in the R for Windows FAQ.  You can include
C++ code in packages and the supplied Makefiles will compile with g++
and link the DLL using g++ (and hence link against libstc++.a).  Use
of C++ I/O may or may not work, and has been seen to crash R.

For other compilers you will need to arrange to produce a DLL with
cdecl (also known as _cdecl or __cdecl) linkage.  The mingw port (and
VC++) uses no `name mangling' at all, so that if for example your
compiler adds leading or trailing underscores you will need to use the
transformed symbol in the call to .C in your R code.  Many compilers
can produce cdecl DLLs by a suitable choice of flags, but if yours
cannot you may need to write some `glue' code in C to interface to the
DLL.

If you use .Fortran this appends an underscore and does no case
conversion at all to the symbol name.  It is normally best to use
.C with compilers other than g77 and map the name manually if necessary.

Care is needed in passing character strings to and from a DLL by .C:
they must be equivalent to the C type char** and null-terminated.  Not
even the mingw g77 Fortran uses null-terminated strings.

WARNING: DLLs made with some compilers reset the FPU in their startup
code (Delphi has been one), and this will cause operations such as
0./0. to crash R.  You can re-set the FPU to the correct values by a
call to the C entry point Rwin_fpset().


Simple Ports
============

If your package has no C nor Fortran nor C++ sources, several steps
can be omitted.

You will need 

suitable versions of Unix tools including make, sh, rm, sed, awk,
mkdir, echo, cp and cat; we have packaged a set at
http://www.stats.ox.ac.uk/pub/Rtools/tools.zip.

perl5, available via http://www.activestate.com/Products/ActivePerl/

All of these need to be installed and in your path, and the
appropriate environment variables set.

For each package you want to install, unpack it to a directory, say
mypkg, in RHOME\src\library, and run

	cd RHOME\src\gnuwin32
	make pkg-mypkg


If you have a Unix/Linux box, it will suffice to zip up the Unix
installation of the package.  Install the package, then

	cd `R RHOME`/library
	zip -r9l /dest/mypkg.zip mypkg

(the -l flag converts to CRLF line endings: it is not necessary but
users may want to read the information files in a Windows editor).

zip is often installed on Linux machines, and sources and binaries for
Unix boxes are available via the Info-Zip site given above.


Non-standard locations
======================

You can specify the location of the package source by PKGDIR and the
library in which to install the package by RLIB, as in

	make PKGDIR=/mysources RLIB=/R/library pkg-mypkg

which installs the package in \mysources\mypkg as \R\library\mypkg.

It may well be simpler to use

	Rcmd INSTALL -l /R/library /mysources/mypkg


Cross-building packages on Linux
================================

It is straightforward to build a package on a ix86-linux system,
although it is not possible (and we have tried, including using WINE)
to cross-build .chm files.  For a package without compiled code and no
OS-specific files you can just zip up the Linux installation of the
package.

First you need to set up the cross-compilers and tools (see file
src/gnuwin32/INSTALL in the full source distribution) and have them
in your path.  We will assume that your Linux installation has Perl5,
unzip and zip.

Edit MkRules to set BUILD=CROSS and the appropriate paths (including
HEADER) as needed.

Then packages can be made as natively, for example by

	cd .../src/gnuwin32
	make PKGDIR=/mysources RLIB=/R/win/library pkg-mypkg
	make PKGDIR=/mysources RLIB=/R/win/library pkgcheck-mypkg
	cd /R/win/library
	zip -r9 /dest/mypkg.zip mypkg

(Rcmd is a Windows executable, so cannot be used.)


Feedback
========

Please send comments and bug reports to

	R-windows@r-project.org

