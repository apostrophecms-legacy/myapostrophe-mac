#!/bin/sh

# You don't need to run this. We run it to build the binaries in bin.tar.gz.

mkdir -p tmp &&
(
  cd tmp &&
  rm -rf * &&
  HERE=$PWD &&
  rm -rf git-master &&
  curl -o git-master.zip -L https://github.com/git/git/archive/master.zip &&
  unzip git-master.zip &&
  cd git-master &&
  make prefix=$HERE NO_DARWIN_PORTS=YesPlease NO_GETTEXT=YesPlease install
  cd .. &&
  tar -zcf ../bin.tar.gz bin libexec
) &&
echo "Updated git binaries"



