#!/bin/bash

set -x

if [ -z "$1" ]; then
  echo "Error: No argument supplied. Please provide 'true' or 'false' for prerelease status."
  exit 1
fi

projects=$(npx nx show projects --type app --affected)
original_dir=$(pwd)

for project in $projects
do
  version=$(grep '"version"' apps/"$project"/"$project"/package.json | awk -F '"' '{print $4}')
  if [ -z "$version" ]; then
    echo "Error: Could not read version from $project/package.json"
    exit 1
  fi

  zip -r "./dist/apps/$project/$project/$project-$version.zip" -j ./dist/apps/"$project"/"$project"/browser

  if [ "$1" == "true" ]; then
    gh release create "$project-$version" "./dist/apps/$project/$project/$project-$version.zip" -t=$project-$version --notes-file=apps/"$project"/"$project"/CHANGELOG.md --prerelease
  elif [ "$1" == "false" ]; then
    gh release create "$project-$version" "./dist/apps/$project/$project/$project-$version.zip" -t=$project-$version --notes-file=apps/"$project"/"$project"/CHANGELOG.md
  else
    echo "Error: Invalid argument. Please use 'true' or 'false'."
    exit 1
  fi
done
