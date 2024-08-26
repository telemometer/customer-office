#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <release-argument>"
  echo "The argument must be either 'version' or 'changelog'"
  exit 1
fi

if [ "$1" != "version" ] && [ "$1" != "changelog" ]; then
  echo "Error: Argument must be either 'version' or 'changelog'"
  exit 1
fi

projects=$(nx show projects --type app --affected)

for project in $projects
do
  if [ "$1" == "changelog" ]; then
    version=$(grep '"version"' apps/$project/$project/package.json | awk -F '"' '{print $4}')
    if [ -z "$version" ]; then
      echo "Error: Could not read version from $project/package.json"
      exit 1
    fi
    npx nx release changelog --version=$version --git-tag=false -p $project
  else
    npx nx release $1 --git-tag=false -p $project
  fi
done
