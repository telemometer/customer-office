#!/bin/bash

set -x

projects=$(npx nx show projects --affected --base=$NX_BASE --head=$NX_HEAD)

for project in $projects
do
  version=$(grep '"version"' apps/"$project"/"$project"/package.json | awk -F '"' '{print $4}')
  if [ -z "$version" ]; then
    echo "Error: Could not read version from $project/package.json"
    exit 1
  fi

  if [ -z "$1" ]; then
    # Publish a stable release
    zip -r "./dist/apps/$project/$project/$project-$version.zip" -j ./dist/apps/"$project"/"$project"/browser
    gh release create release/"$project"/"$version" "./dist/apps/$project/$project/$project-$version.zip" -t=release/"$project"/"$version" --notes-file=apps/"$project"/"$project"/CHANGELOG.md
  else
    # Publish a pre-release with SHA
    pushd ./dist/apps/"$project"/"$project"/browser
    npm version $version-$1
    popd
    zip -r "./dist/apps/$project/$project/$project-$version-$1.zip" -j ./dist/apps/"$project"/"$project"/browser
    gh release create "$project/$version-$1" "./dist/apps/$project/$project/$project-$version-$1.zip" -t=$project/$version-$1 --notes-file=apps/"$project"/"$project"/CHANGELOG.md --prerelease
  fi
done
