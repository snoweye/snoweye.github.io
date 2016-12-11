@ECHO OFF

rem ### Set environment variables.
SET R_VER=3.0.1
SET PBDMPI_VER=0.2-3

rem ### Set environment variables.
SET R_HOME=C:\Program Files\R\R-%R_VER%\
SET RHOME=%R_HOME%
SET RBIN=%R_HOME%bin\
SET RTOOLS=C:\Rtools\bin\
SET MINGW=C:\Rtools\gcc-4.6.3\bin\
SET MPI_ROOT=C:\Program Files\Microsoft MPI\

IF NOT DEFINED PATH_ORG SET PATH_ORG=%PATH%
SET PATH=%MPI_ROOT%Bin\;%RHOME%;%RBIN%;%RTOOLS%;%MINGW%;%PATH_ORG%

rem ### Build Windows binary.
R CMD INSTALL --build --html pbdMPI_%PBDMPI_VER%.tar.gz
R CMD INSTALL pbdMPI_%PBDMPI_VER%.zip
