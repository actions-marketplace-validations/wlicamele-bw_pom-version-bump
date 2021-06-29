
# Pom and Changelog Version Updater

This action is used to either find the current version and bump the version number **OR** explicitly set the version number and then [optionally] update the changelog accordingly

## Inputs


### `bumpVersionType`

> **Description:** Parameter to bump version number or set version number  
> **Options:** `set` or `bump`  
> **Default:** `bump`  
> **Required** : false  
 

### `bumpVersion`

> **Description:** Type of version bump  
> **Options:** `major`, `minor`, `patch`  
> **Default:** `patch`  
> **Required** : false  

### `setVersion`

> **Description:** Version number to explicitly set  
> **Options:** `major.minor.patch`  
> **Required** : false  

### `pomLocations`

> **Description:** Location(s) of pom file(s). Comma seperated list  
> **Options:** string  
> **Default:** `pom.xml`  
> **Required** : false  

### `bumpChangelog`

> **Description:** Add changelog entry?  
> **Options:** `true` or `false`  
> **Default:** `false`  
> **Required** : false  

### `changelogDesc`

> **Description:** Changelog message, PR title should be used for Dependabot PRs  
> **Options:** string  
> **Required** : false  

### `pomVersionTag`

> **Description:** The POM Version tag name  
> **Options:** string  
> **Default:** `artifact-version`  
> **Required** : false 

### `mainBranchName`

> **Description:** Main branch; main or master
> **Options:** string  
> **Default:** `master`  
> **Required** : false 


## Outputs

### `versionNumber`

  Description: The updated Version Number

## Example usage
```yaml
on:
  pull_request:
    types: [opened]

jobs:
  test:
    runs-on: ubuntu-latest
    if: github.event.pull_request.user.login == 'dependabot-preview[bot]' || github.event.pull_request.user.login == 'dependabot[bot]'
    name: A job to bump POM and ChangeLog
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with: 
          fetch-depth: 0
      - name: Uses POM Version Bump
        uses: wlicamele-bw/pom-version-bump@v1.0
        id: bump
        with:
          bumpVersionType: bump
          bumpVersion: patch
          bumpChangelog: true
          changelogDesc: ${{ github.event.pull_request.title }}
      - name: Get the version number
        run: echo "The Version Number is ${{ steps.bump.outputs.versionNumber }}"
```

