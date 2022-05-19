package: FEDRA
version: v1.5.22
tag: master

source: https://github.com/antonioiuliano2/fedra

requires:
  - GCC-Toolchain
  - ROOT

--- 
#!/bin/bash 
rsync -a $SOURCEDIR/* $BUILDDIR

export FEDRA_INSTALL_DIR=$INSTALLROOT

chmod u+x install.sh
./install.sh

rsync -a $INSTALLROOT/src/*/*.pcm $INSTALLROOT/lib
rsync -a $INSTALLROOT/src/*/*/*.pcm $INSTALLROOT/lib
rsync -a $INSTALLROOT/macros/rootlogon_root6x.C $INSTALLROOT/macros/rootlogon.C
rsync -a $INSTALLROOT/macros_root6/*.C $INSTALLROOT/macros/

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
cat > "$MODULEFILE" <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0

# setting environment (aka setup_new.sh in alibuild language)
setenv FEDRA_ROOT \$::env(HOME)/fedra_sndsw
prepend-path LD_LIBRARY_PATH \$::env(FEDRA_ROOT)/lib
prepend-path PATH \$::env(FEDRA_ROOT)/bin
append-path PYTHONPATH \$::env(FEDRA_ROOT)/python
EoF
