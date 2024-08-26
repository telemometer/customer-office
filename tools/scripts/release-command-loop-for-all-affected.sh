#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <release-argument> [<preid>]"
  echo "The first argument must be either 'version' or 'changelog' or 'publish'"
  echo "The second argument is optional and is the preid (e.g., 'alpha', 'beta', etc.)"
  exit 1
fi

if [ "$1" != "version" ] && [ "$1" != "changelog" ] && [ "$1" != "publish" ]; then
  echo "Error: First argument must be either 'version' or 'changelog' or 'publish'"
  exit 1
fi

preid="$2"

projects=$(nx show projects --type app --affected)

for project in $projects
do
  version=$(grep '"version"' apps/"$project"/"$project"/package.json | awk -F '"' '{print $4}')
  if [ -z "$version" ]; then
    echo "Error: Could not read version from $project/package.json"
    exit 1
  fi

  if [ "$1" == "version" ]; then
    if [ -z "$preid" ]; then
      npx nx release version -p "$project" --git-tag=false
    else
      npx nx release version --version="$version-$preid" -p "$project" --git-tag=false
    fi
  elif [ "$1" == "changelog" ]; then
    npx nx release changelog --version="$version" -p "$project" --git-tag=false
  elif [ "$1" == "publish" ]; then
    if [ -z "$preid" ]; then
      zip -r "./dist/apps/$project/$project/$project-$version.zip" -j ./dist/apps/"$project"/"$project"/browser
      gh release create "$project-$version" "./dist/apps/$project/$project/$project-$version.zip" -t=$project-$version --notes-file=apps/"$project"/"$project"/CHANGELOG.md --latest
    else
      zip -r "./dist/apps/$project/$project/$project-$version-$preid.zip" -j ./dist/apps/"$project"/"$project"/browser
      gh release create "$project-$version-$preid" "./dist/apps/$project/$project/$project-$version-$preid.zip" -t=$project-$version-$preid --notes-file=apps/"$project"/"$project"/CHANGELOG.md --draft --prerelease
    fi
  fi
done
