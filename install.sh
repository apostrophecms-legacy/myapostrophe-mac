#!/bin/sh

# TODO
#
# Pair this with some really simple HOWTOs for your little
# Apostrophe site now that you have it

NODE_VERSION="0.10.22"
MONGODB_VERSION="2.4.8"

############################################
# Check for Mountain Lion or better

float_test() {
     echo | awk 'END { exit ( !( '"$1"')); }'
}

MY_MACOS_VERSION=`sw_vers -productVersion`
MIN_MACOS_VERSION="10."
(float_test "$MY_MACOS_VERSION > $MIN_MACOS_VERSION" ||
  (
  echo "Sorry, you must have at least MacOS X Mountain Lion."
  exit 1
  )
) || exit 1




(
  ############################################
  # Create our little world of up-to-date tools that don't require sudo
  mkdir -p ~/myapostrophe &&
  cd ~/myapostrophe &&
  mkdir -p etc &&
  mkdir -p bin &&
  mkdir -p lib &&
  mkdir -p db &&
  mkdir -p run &&
  mkdir -p share &&
  mkdir -p sites &&
  mkdir -p tmp &&




  ############################################
  # Install or update node.js
  echo "Installing node" &&
  (
    rm -rf tmp/* &&
    cd tmp &&
    curl -o node.tar.gz http://nodejs.org/dist/v0.10.22/node-v${NODE_VERSION}-darwin-x86.tar.gz &&
    tar -zxf node.tar.gz --strip-components=1 &&
    # rsync is much better at updating things than cp
    rsync -a bin ~/myapostrophe &&
    rsync -a lib ~/myapostrophe &&
    rsync -a share ~/myapostrophe
  ) &&




  ############################################
  # Install or update MongoDB
  echo "Installing MongoDB" &&
  (
    rm -rf tmp/* &&
    cd tmp &&
    curl -o mongodb.tar.gz http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-${MONGODB_VERSION}.tgz &&
    tar -zxf mongodb.tar.gz --strip-components=1 &&
    rsync -a bin ~/myapostrophe
  ) &&





  ############################################
  # Install imagecrunch
  (
    curl -o bin/imagecrunch https://github.com/punkave/imagecrunch/releases/download/1.0.0/imagecrunch &&
    chmod 700 bin/imagecrunch &&
    mkdir -p share/man/man1 &&
    curl -o share/man/man1/imagecrunch.1 https://raw.github.com/punkave/imagecrunch/master/imagecrunch/imagecrunch.1
  ) &&




  ############################################
  # apos-env: a script to add our tools to the environment
  cat << EOM > bin/apos-env &&
#!/bin/sh
export PATH=\$PATH:~/myapostrophe/bin
export DYLD_LIBRARY_PATH=\$DYLD_LIBRARY_PATH:~/myapostrophe/lib
export MANPATH=$MANPATH:~/myapostrophe/share/man
EOM
  chmod 700 bin/apos-env &&
  # Add apos-env to .profile but not if it is already there
  ( grep -q apos-env ~/.profile || echo "source ~/myapostrophe/bin/apos-env" >> ~/.profile ) &&




  ############################################
  # Script to start mongodb
  cat << EOM > bin/startmongodb &&
#!/bin/sh
mongod --dbpath=\$HOME/myapostrophe/db --quiet --pidfilepath=\$HOME/myapostrophe/run/mongodb.pid &
EOM
  chmod 700 bin/startmongodb &&



  ############################################
  # Script to stop mongodb
  cat << EOM > bin/stopmongodb &&
#!/bin/sh
kill \`cat ~/myapostrophe/run/mongodb.pid\`
EOM
  chmod 700 bin/stopmongodb &&




  ############################################
  # Script to start an Apostrophe site. Also starts mongodb if needed
  cat << EOM > bin/apos-start
#!/bin/sh
SITE="\$1"
if [ -z "\$SITE" ]; then
  SITE="apostrophe-sandbox"
fi
( (ps auxw | grep mongod | grep -q -v grep) || (echo "Starting mongodb..." && startmongodb && sleep 5) ) &&
cd ~/myapostrophe/sites/\$SITE &&
echo "Starting the site. When you are finished with it, press Control-C." &&
node app
EOM
  chmod 700 bin/apos-start &&




  ############################################
  # Load apos-env so this terminal window can be used immediately
  source ~/myapostrophe/bin/apos-env &&




  ############################################
  # Go get the Apostrophe sandbox if necessary. If it is not there assume this
  # is a first install; launch the sandbox and open the browser too just to
  # be swank
  if [ ! -d sites/apostrophe-sandbox ]; then
    git clone https://github.com/punkave/apostrophe-sandbox.git sites/apostrophe-sandbox &&
    (cd sites/apostrophe-sandbox && npm install && node app apostrophe:reset) &&
    (
      echo "Done! Since this is your first install, I'll start the"
      echo "sandbox site for you, then open your browser in 10 seconds"
      echo "so you can explore the sandbox."
      echo
      echo "You may start your sandbox site again at any time by typing:"
      echo "apos-start"
      echo
      echo "And then accessing:"
      echo
      echo "http://localhost:3000/"
      ( sleep 10 && open http://localhost:3000/ ) &
      bin/apos-start
    )
    exit 0
  fi &&



  ############################################
  # That's all folks
  echo "Done! Everything has been updated."
) || (echo "Something went wrong."; exit 1)

