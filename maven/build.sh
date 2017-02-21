#!/usr/bin/env bash

mvn clean

mvn install -Dmaven.test.skip=true

mv ./target/k2bigdata-demo-feb.war ./target/k2bigdata.war

echo "Build success. target: ./target/k2bigdata.war"
