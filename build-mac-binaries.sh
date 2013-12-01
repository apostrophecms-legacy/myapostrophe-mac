#!/bin/sh

(
  mkdir -p bin &&
  mkdir -p tmp &&
  cd tmp &&
  rm -rf git-master &&
  curl -o git-master.zip -L https://github.com/git/git/archive/master.zip &&
  unzip git-master.zip &&
  cd git-master &&
  make NO_DARWIN_PORTS=YesPlease NO_GETTEXT=YesPlease &&
  cp git git-upload-pack git-receive-pack git-upload-archive git-shell ../../bin &&
  (
    cd ./contrib/credential/osxkeychain &&
    make &&
    cp git-credential-osxkeychain ../../../../../bin
  )
) &&
echo "Updated git binaries" &&
tar -zcf bin.tar.gz bin
