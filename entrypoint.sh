#!/bin/bash

bumpVersionType=$1
bumpVersion=$2
setVersion=$3
pomLocations=$4
bumpChangelog=$5
changelogDesc=$6
pomVersionTag=$7

echo "Bump Version Type: $bumpVersionType"
echo "Bump Version: $bumpVersion"
echo "Set Version: $setVersion"
echo "POM Location(s): $pomLocations"
echo "Bump changelog: $bumpChangelog"
echo "Changelog Desc: $changelogDesc"
echo "POM Version Tag: $pomVersionTag"

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done

IFS="," read -a pomLocationsArray <<< "$pomLocations"

git fetch
git show origin/main:pom.xml > pom.xml.BAK

# Find Next_Version number
if [[ "$bumpVersionType" == "bump" ]]; then
	if test -f "pom.xml"; then
        CURR_VERSION=$(sed -n "s:.*<$pomVersionTag>\(.*\)</$pomVersionTag>.*:\1:p" pom.xml.BAK)
        echo "Current Version: ${CURR_VERSION}"

        MAJOR=$(echo ${CURR_VERSION} | cut -d '.' -f 1)
        MINOR=$(echo ${CURR_VERSION} | cut -d '.' -f 2)
        PATCH=$(echo ${CURR_VERSION} | cut -d '.' -f 3 | cut -d '-' -f 1) 

        case "$bumpVersion" in
            patch)
                ((PATCH++))
            ;;
            minor)
                ((MINOR++))
                PATCH=0
            ;;	
            major)
                ((MAJOR++))
                MINOR=0
                PATCH=0
            ;;	
        esac
    NEXT_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    else 
        echo "pom.xml does not exist"
        exit
    fi
		
elif [[ "$bumpVersionType" == "set" ]]; then
	if [[ -z "$setVersion" ]]; then
		echo "Cannot set version, no version specified"
		exit
	else
		NEXT_VERSION="$setVersion"
	fi
else
	echo "${bumpVersionType} is not a valid bumpVersionType"
	exit
fi
echo "Next Version: ${NEXT_VERSION}"

for (( i=0; i<${#pomLocationsArray[@]}; i++ )); do
    	# Update _pom.xml_ with the new Version Number
	# i.bak is used as in-place flag that works both on Mac (BSD) and Linux
	if test -f "${pomLocationsArray[$i]}"; then
        sed -i.bak "s:<artifact-version>.*</artifact-version>:<artifact-version>${NEXT_VERSION}-SNAPSHOT</artifact-version>:" "${pomLocationsArray[$i]}"
	    rm "${pomLocationsArray[$i]}.bak"
	    echo "Updated Version number in ${pomLocationsArray[$i]} to ${NEXT_VERSION}"
    else
        echo "${pomLocationsArray[$i]} does not exist"
        exit
    fi    
done

git checkout -m origin/main CHANGELOG.md
# i.bak is used as in-place flag that works both on Mac (BSD) and Linux
if [[ "$bumpChangelog" == "true" ]]; then
	if test -f "CHANGELOG.md"; then
        sed -i.bak "3i* v${NEXT_VERSION}\n    * ${changelogDesc}" CHANGELOG.md
	    rm CHANGELOG.md.bak
	    echo "Changelog updated with ${NEXT_VERSION}: ${changelogDesc} "
    else
        echo "Changelog.md does not exist"
        exit
    fi
fi

# Commit changes
git fetch
git checkout ${GITHUB_HEAD_REF}
git pull
git config user.name github-actions
git config user.email github-actions@github.com
for (( i=0; i<${#pomLocationsArray[@]}; i++ )); do
	if test -f "${pomLocationsArray[$i]}"; then
        git add "${pomLocationsArray[$i]}"
    fi    
done
git add CHANGELOG.md
git commit -m "GitHub Action - pom.xml and CHANGELOG.md Automations"
git push origin HEAD:"${GITHUB_HEAD_REF}"
