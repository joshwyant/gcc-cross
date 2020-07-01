#!/bin/bash
set -e

source vars.sh

# Fix patches with osname
PERLCMD="s/{{OSNAME}}/${OS_NAME}/g"
perl -pi -e $PERLCMD *.patch
PERLCMD="s/{{OSNAME_UPPER}}/${OS_NAME^^}/g"
perl -pi -e $PERLCMD *.patch

# Fix patches with machine
PERLCMD="s/{{MACHINE}}/${MACHINE}/g"
perl -pi -e $PERLCMD *.patch
