package: SNDstyle
version: main
source: https://github.com/SND-LHC/SNDstyle
requires:
 - ROOT
prepend_path:
  PYTHONPATH: "$SNDSTYLE_ROOT"
---
#!/bin/bash

cd $SOURCEDIR

cp SNDstyle.py "$INSTALLROOT/"

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"

alibuild-generate-module > $MODULEFILE

cat >> "$MODULEFILE" <<EoF
# Our environment
set SNDSTYLE_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path PYTHONPATH \$SNDSTYLE_ROOT
EoF
