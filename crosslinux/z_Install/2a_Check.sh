#!/bin/sh

source ./vars.sh

# Check system and tools

# Check compiler
APP=`which gcc`
if [ "$APP" != "" ]; then
  echo 1\) compiler - Ok
else
  echo 1\) compiler - Not found
fi

# Check pkg-config
APP=`which pkg-config`
if [ "$APP" != "" ]; then
  echo 2\) pkg-config - Ok
else
  echo 2\) pkg-config - Not found
fi

# Check python distutils
APP=`python -c "import distutils" 2>&1`
if [ "$APP" == "" ]; then
  echo 2\) python-setuptools - Ok
else
  echo 2\) python-setuptools - Not found
fi

# Check autoconf
APP=`which autoconf`
if [ "$APP" != "" ]; then
  echo 4\) autoconf - Ok
else
  echo 4\) autoconf - Not found
fi

# Check libtool
APP=`which libtool`
if [ "$APP" != "" ]; then
  echo 5\) libtool - Ok
else
  echo 5\) libtool - Not found
fi

# Check mingw
APP=`which $CROSS_HOST-gcc`
if [ "$APP" != "" ]; then
  echo 6\) compiler "$CROSS_HOST" - Ok
else
  echo 6\) compiler "$CROSS_HOST" - Not found
fi

# Check wine + binfmt_misc
BMFT=`cat /proc/sys/fs/binfmt_misc/wine 2>/dev/null`
if [ "$BMFT" == "" ]; then
  echo 7\) wine - Ok \(No binfmt support\)
else
  echo 7\) wine - Warning: binfmt support enabled
fi

# Check Perl XML::Simple module
PERLXML=`perl -e "use XML::Simple" 2>&1`
if [ "$PERLXML" == "" ]; then
  echo 8\) Perl XML::Simple - Ok
else
  echo 8\) Perl XML::Simple - Not found
fi

# Check intltool-update
APP=`which intltool-update`
if [ "$APP" != "" ]; then
  echo 9\) intltool-update - ok
else
  echo 9\) intltool-update - Not found
fi


# Check vars.sh
echo
if [ -f ./vars.sh ]; then
  if [ -x ./vars.sh ]; then
    echo vars.sh - Ok
  else
    echo vars.sh - Not executable
  fi
else
  echo vars.sh - Not found
fi

if [ "$NATIVEPREFIX" == "" ]; then
  echo \$NATIVEPREFIX - Not set, check vars.sh
else
  if [ -d "$NATIVEPREFIX" ]; then
    echo \$NATIVEPREFIX - Ok
  else
    echo \$NATIVEPREFIX - Not found, run 3_PrepBuild.sh
  fi
fi

if [ "$WIN32PREFIX" == "" ]; then
  echo \$WIN32PREFIX - Not set, check vars.sh
else
  if [ -d "$WIN32PREFIX" ]; then
    echo \$WIN32PREFIX - Ok
  else
    echo \$WIN32PREFIX - Not found, run 3_PrepBuild.sh
  fi
fi

