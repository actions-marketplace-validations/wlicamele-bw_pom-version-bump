#!/bin/sh -l
bumpVersionType=$1
bumpVersion=$2
setVersion=$3
pomLocations=$4
bumpChangelog=$5
changelogDesc=$6

echo "Bump version type: $bumpVersionType"
echo "Bump version: $bumpVersion"
echo "Set version: $setVersion"
echo "POM Location(s): $pomLocations"
echo "Bump changelog $bumpChangelog"
echo "Changelog Desc: $changelongDesc"
