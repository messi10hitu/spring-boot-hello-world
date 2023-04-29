#!/bin/bash

# git clone needs to be added
git pull https://github.com/messi10hitu/spring-boot-hello-world.git

branch=$(git branch --show-current)
echo "branch : ${branch}"

SEMVER=$(GitVersion /showvariable SemVer)
echo "the sementic version: ${SEMVER}"

OLD_VERSION=$SEMVER
printf "Old version : %s\n" "$OLD_VERSION"

# This command extracts the text after the last hyphen in the SEMVER string and stores it in a variable called TAG.
# the general syntax of release is v1.0.1-sprint1, 1.5.0-beta.8 or release-v1.0.1
TAG="${SEMVER##*-}"
printf "Tag : %s\n" "$TAG"

# This command extracts the text after the last dot in the TAG string and stores it in a variable called PRE_RELEASE_NUMBER.
# may be it is related to this v1.0.1, beta.8
PRE_RELEASE_NUMBER="${TAG##*.}"
printf "PRE_RELEASE_NUMBER : %s\n" "$PRE_RELEASE_NUMBER"

INCREASED_NUMBER=$((PRE_RELEASE_NUMBER+1))
printf "Increased number : %d\n" "$INCREASED_NUMBER"

MAJOR=$(GitVersion /showvariable Major)
MINOR=$(GitVersion /showvariable Minor)
PATCH=$(GitVersion /showvariable Patch)
TAG=$(GitVersion /showvariable PreReleaseLabelWithDash) # "-beta.8"
echo "Major: ${MAJOR}, Minor:${MINOR}, Patch: ${PATCH}, Tag: ${TAG} "


NEW_VERSION="${MAJOR}"'.'"${MINOR}"'.'"${PATCH}""${TAG}"'.'"${INCREASED_NUMBER}"
printf "New version : %s\n" "$NEW_VERSION"
# 1.5.0-beta.8.9 or 1.5.0-beta.9


echo "finding new commits and files"
find . -type f \( -iname \*.yaml -o -iname \*.xml \) | xargs sed -i '' "s/${OLD_VERSION}/${NEW_VERSION}/g"

echo "pushing commits with new version"
git push origin "${branch}"

echo "adding a tag for new version"
git tag -a "${NEW_VERSION}" -m "testing for new release version"

echo "pushing the new tag to master"
git push --tags origin master


