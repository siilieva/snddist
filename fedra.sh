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
rsync -a $BUILDDIR/* $INSTALLROOT
ls -alh $INSTALLROOT
cd $INSTALLROOT
source install.sh
cp src/*/*.pcm lib
cp src/*/*/*.pcm lib
cp macros/rootlogon_root6x.C macros/rootlogon.C
cp macros_root6/*.C macros

# make command does not work, do it by hand (include links become broken otherwise)
rsync -a src/*/*.h $INSTALLROOT/include/
rsync -a src/*/*/*.h $INSTALLROOT/include/


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
setenv FEDRA_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
append-path LD_LIBRARY_PATH \$::env(FEDRA_ROOT)/lib
append-path PATH \$::env(FEDRA_ROOT)/bin
append-path PYTHONPATH \$::env(FEDRA_ROOT)/python
EoF
