#!/usr/bin/env bash

#####################################################################
#
# Maven init local lib script
#
#
# author   : lidong9144@163.com
# version  : 0.0.1
#
#####################################################################

groupid="com.k2data.lib"

for filename in `ls ./lib`;
do
  name=${filename%.jar}
  artifactid=${name%-[0-9]*}
  version=${name##*-}

  mvn install:install-file \
        -Dfile=./lib/$filename \
        -DgroupId=$groupid \
        -DartifactId=$artifactid \
        -Dversion=$version \
        -Dpackaging=jar
done
