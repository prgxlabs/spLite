#!/bin/bash

# Empty out the dist directory
echo " == Emptying out dist directory"
rm -rf dist/*

# Get the current version
CurVersion="0.0.0"
LineMatches=$(grep "version=" setup.py)
Regex="version=\"(.*)\""
if [[ $LineMatches =~ $Regex ]]; then
    CurVersion=${BASH_REMATCH[1]}
fi

# Get the git branch version
LineMatches=$(git branch | grep "*")
Regex="\* (.*)"

if [[ $LineMatches =~ $Regex ]]; then
    BranchName=${BASH_REMATCH[1]}
fi

echo " == Current branch is $BranchName"

# Get the number and increment by one
Regex="(.*)\.(.*)\.(.*)"

if [[ $CurVersion =~ $Regex ]]; then
    MajorVersion=${BASH_REMATCH[1]}
    MinorVersion=${BASH_REMATCH[2]}
    BuildVersion=${BASH_REMATCH[3]}
fi

CurBranch=${MajorVersion}.${MinorVersion}
NewBuildVersion=$((BuildVersion + 1))
NewVersion=${MajorVersion}.${MinorVersion}.${NewBuildVersion}

echo " == Building $NewVersion"
# Create branch
echo " == Creating new branch for build"
git checkout -b build_${NewVersion}

# Update build number with new one
echo " == Replacing build number in setup.py"
Replacement="s/${CurVersion}/${NewVersion}/g"
find . -type f -name "setup.py" -exec sed -i "$Replacement" {} \;

# Commit to new branch
echo " == Adding changes to new branch"
git add .
echo " == Committing new branch"
git commit -m "Build version ${NewVersion}"

# Build the distribution
echo " == Building the source distribution (sdist)"
python3 setup.py sdist upload -r local

# If the call was successfull, publish it
if [ $? -eq 0 ]; then
    echo " == Merging changes into original branch"
    git merge --no-edit build_${NewVersion}
    echo " == Checking out original branch"
    git checkout $BranchName
    echo " == Merging changes from build branch"
    git merge --no-edit build_${NewVersion}
else
    # Undo changes
    git reset --hard
    git clean -df

    # Check out original branch
    echo " == Checking out original branch"
    git checkout $BranchName

    # Delete build branch
    echo " == Deleting build branch"
    git branch -D build_${NewVersion}
fi

