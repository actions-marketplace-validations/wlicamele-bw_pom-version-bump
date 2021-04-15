
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

### `bumpChangelog`

> **Description:** Changelog message, PR title should be used for Dependabot PRs  
> **Options:** string  
> **Required** : false  

## Outputs

### `versionNumber`

  Description: The updated Version Number

## Example usage
```yaml
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    name: A job to bump POM and ChangeLog
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Uses POM Version Bump
        uses: ./  #Uses an action in the root directory
        id: bump
        with:
          bumpVersionType: bump
          bumpVersion: patch
          bumpChangelog: true
          changelogDesc: ${{ github.event.pull_request.title }}
      - name: Get the version number
        run: echo "The Version Number is ${{ steps.bump.outputs.versionNumber }}"
```