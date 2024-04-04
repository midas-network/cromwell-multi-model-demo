#!/bin/bash

echo ""
echo "******************************************************************************"
echo "*       MIDAS Cromwell / Multi-model Demo                                    *"
echo "*                                                                            *"
echo "* This script demonstrates the execution of                                  *"
echo "* -- Epispot (a Python package)                                              *"
echo "* -- Bayesian disease model (a Python library) using                         *"
echo "* -- SEIR model (a R library)                                                *"
echo "* using a WDL file run via the Cromwell workflow engine.                     *"
echo "*                                                                            *"
echo "* Epispot:  https://github.com/epispot/epispot                               *"
echo "* Bayesian: https://github.com/midas-network/bayesian-covid-model-demo.git   *"
echo "* SEIR:     https://github.com/midas-network/cromwell-SEIR-basic             *"
echo "*                                                                            *"
echo "* Cromwell: https://github.com/broadinstitute/cromwell                       *"
echo "*                                                                            *"
echo "* author: Jeff Stazer, jbs82@pitt.edu                                        *"
echo "******************************************************************************"
echo ""


# https://stackoverflow.com/questions/7334754/correct-way-to-check-java-version-from-bash-script
# returns the JDK version.
# 8 for 1.8.0_nn, 9 for 9-ea etc, and "no_java" for undetected
jdk_version() {
  local result
  local java_cmd
  if [[ -n $(type -p java) ]]
  then
    java_cmd=java
  elif [[ (-n "$JAVA_HOME") && (-x "$JAVA_HOME/bin/java") ]]
  then
    java_cmd="$JAVA_HOME/bin/java"
  fi
  local IFS=$'\n'
  # remove \r for Cygwin
  local lines=$("$java_cmd" -Xms32M -Xmx32M -version 2>&1 | tr '\r' '\n')
  if [[ -z $java_cmd ]]
  then
    result=no_java
  else
    for line in $lines; do
      if [[ (-z $result) && ($line = *"version \""*) ]]
      then
        local ver=$(echo $line | sed -e 's/.*version "\(.*\)"\(.*\)/\1/; 1q')
        # on macOS, sed doesn't support '?'
        if [[ $ver = "1."* ]]
        then
          result=$(echo $ver | sed -e 's/1\.\([0-9]*\)\(.*\)/\1/; 1q')
        else
          result=$(echo $ver | sed -e 's/\([0-9]*\)\(.*\)/\1/; 1q')
        fi
      fi
    done
  fi
  echo "$result"
}

echo "Checking JAVA installation and version..."
java_ver="$(jdk_version)"
if (( $java_ver > 10 ))
then
	java_installed=true
  echo "  JAVA installed and acceptable version found"
else
	echo "  Error: This application requires a minimum JAVA version of 11."
	exit 1
fi

echo "Checking DOCKER installation and version..."
if [[ $(which docker) && $(docker --version) ]]
then
	docker_installed=true
  echo "  Docker installation found"
else
	echo "  Error: This application requires Docker to be installed."
  echo "    Please install Docker using the installation instructions from:"
  echo "      https://docs.docker.com/get-docker/"
  echo "    Rerun this script once you've installed Docker."
	exit 1
fi 

#echo "java " + $java_installed
#echo "docker " + $docker_installed

echo "Pulling Docker library ..."
docker pull python

checksum="f9581657e0484c90b5ead0f699d8d791f94e3cabe87d8cb0c5bfb21d1fdb6592  cromwell-86.jar"
echo "Looking for cromwell-86.jar..."
if [[ -f "cromwell-86.jar" ]]; then
  echo "  cromwell-86.jar found."
else
  echo "  cromwell-86.jar not found..."
  if which wget >/dev/null; then
    echo "  Downloading cromwell-86.jar via wget."
    wget -q --show-progress https://github.com/broadinstitute/cromwell/releases/download/86/cromwell-86.jar
 else
    echo "  Error: Cannot download cromwell-86.jar, wget is not available."
    echo "    Please install wget or download the following file to this directory:"
    echo "      https://github.com/broadinstitute/cromwell/releases/download/86/cromwell-86.jar "
    echo "    Rerun this script once you've either installed wget or downloaded cromwell-86.jar"
    exit 1
  fi
fi

echo "Verifying cromwell-86.jar..."
if [[ $(shasum -a 256 cromwell-86.jar) = $checksum ]]; then
  echo "  cromwell-86.jar verified!";
else
  echo "  Error: Couldn't verify cromwell-86.jar, please delete the .jar and run this script again."
  exit 1
fi

echo "Running Cromwell workflow ..."
# java -Dconfig.file=cromwell_config.conf -jar cromwell-86.jar run idmWorkflow.wdl
java -jar cromwell-86.jar run idmWorkflow.wdl

echo ""
echo "******************************************************************************"
echo "*       MIDAS Cromwell / Multi-model Demo                                    *"
echo "*                                                                            *"
echo "* Cromwell workflow has completed.  Results can be found at:                 *"
echo "$(pwd)/results"
echo "*                                                                            *"
echo "******************************************************************************"
echo ""

