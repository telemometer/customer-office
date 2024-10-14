#!/bin/bash

set -x

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

  if [ -z "$1" ]; then
    gh release create "$project-$version-$1" "./dist/apps/$project/$project/$project-$version-$1.zip" -t=$project-$version-$1 --notes-file=apps/"$project"/"$project"/CHANGELOG.md
  else
    gh release create "$project-$version" "./dist/apps/$project/$project/$project-$version.zip" -t=$project-$version --notes-file=apps/"$project"/"$project"/CHANGELOG.md --prerelease
    sddfdsgjfhsdg --rel "$1"
  fi
done
