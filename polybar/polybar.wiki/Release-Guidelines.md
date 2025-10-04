

**❗️❗️❗️The information on this page is outdated starting with polybar version 3.5.0❗️❗️❗️**

Please find the newest version of this document [here](https://polybar.readthedocs.io/en/latest/dev/release-workflow.html).

---

We try to follow [Semantic Versioning](https://semver.org/) in this project. This basically means breaking changes require a new major release, new features require a minor release and bug fixes require a patch release. For unintended breaking changes, we don't always bump the major version number, it depends on the severity.

*From version 3.2.0 onwards we try to follow the following guidelines on how to do releases and where to put them.*

# Contents
- [Publishing a new Release](#publishing-a-new-release)
    - [Minor Release](#minor-release)
    - [Patch Release](#patch-release)
    - [Release PR](#release-pr)
    - [Changelog](#changelog)
    - [After Release Checklist](#after-release-checklist)
    - [Deprecations](#deprecations)

## Publishing a new Release
There can be three types of releases: major, minor and patch releases. The process for major and minor releases is the same, we're going to reference both of them as minor releases below.

All releases, after their release PR was merged, have to be drafted and released with the [github release tool](https://github.com/polybar/polybar/releases/new), this ensures that they show up in github's [list of releases](https://github.com/polybar/polybar/releases) and that they are properly tagged.

### Minor Release
A minor release marks the current state of the `master` branch as the new version. To retain our ability to do patch releases even when there have been new features added, on every minor release, a new branch is created for that release. The name of that branch is the numeric name of the release without the patch number (e.g. 3.2 or 4.0), this avoids name conflicts with the version tags. The branch points to the release commit on the `master` branch.
The release commit is created by first opening a release PR (see [`#1338`](https://github.com/polybar/polybar/pull/1338) or [`#863`](https://github.com/polybar/polybar/pull/863)) and after review squashing it into a single commit containing the changelog for that release.

After all this is done, a new release is drafted and published with the [github release tool](https://github.com/polybar/polybar/releases/new) with the target set to the release branch. Ideally the release text is already drafted and only has to be published.

This way we can do normal development on the `master` branch and fix errors in minor releases by cherry-picking commits onto the release branch without having to release all the work on `master` (which would force us to do a minor release).

The milestone for the next minor release should be kept small, so that it can be completed and a new minor release can be published within a few months.

### Patch Release
Patch releases are required when we want to release bug fixes. Generally the bug was already fixed in `master` and we want it to be in a patch release. To do this, we open a PR, which cherry-picks the bug fix onto the release branch.

This PR with all the bug fixes, is at the same time the release PR and must contain the release commit (with the changelog in its commit message) as its last commit. This ensures that the head of any release branch is always a numbered release and not some unreleased dangling commit. This means that the patch release PR is **not** squashed but rebased.

After the release PR is reviewed and merged, the same as with minor releases, a new release is drafted and published in the github release tool.

Patch releases should be done only every few bug fixes as to reduce the overhead of publishing a new release for every little fix. More critical bug fixes can of course be published on their own.

### Release PR
As already mentioned, every release needs to be preceded by a release PR which updates the version numbers and gives some explanation as to why a release is needed.

The release PR needs to update the version number in:
* `version.txt`

After it is reviewed, the release PR is squashed and the changelog for the new version is copied into the commit message body.
**Note:** For patch releases the release PR also contains the bug fix commits, so it is not squashed.

### Changelog
Each release should come with a changelog briefly explaining what has changed for the user. It should generally be separated into 'Deprecations', 'Features', and 'Fixes', with 'Breaking Changes' listed separately at the top.

See [old releases](https://github.com/polybar/polybar/releases) for how to format the changelog.

Since major releases generally break backwards compatibility in some way, their changelog should also prominently feature precisely what breaking changes were introduced. If suitable, maybe even separate documentation dedicated to the migration should be written.

### After Release Checklist
After any release is published, the following things should be done:

* Make sure all the new functionality is documented on the wiki
* Mark deprecated features appropriately
* Remove all `unreleased` notes from the wiki (not for patch releases)
* Inform packagers of new release in
  [`#1971`](https://github.com/polybar/polybar/issues/1971). Mention any
  dependency changes and any changes to the build workflow. Also mention when new files are created by the installation.
* Create a source archive named `polybar-@POLYBAR_VERSION@.tar` that includes the submodule source code with the following commands and attach it to the github release:
```bash
git clone --branch @POLYBAR_VERSION@ --recursive git://github.com/polybar/polybar.git
find polybar -name ".git" -exec rm -rf {} \+
tar cf polybar-@POLYBAR_VERSION@.tar polybar
```
* Update the github release with a download section that contains a link to `polybar-@POLYBAR_VERSION@.tar` and its sha256.
* Create a PR that updates the AUR `PKGBUILD` files (push after the `.tar` file was created). `polybar-git` only should be updated on minor releases. This PR is always merged into `master`, even for patch releases. This means that only master contains up-to-date `PKGBUILD`s.

### Deprecations
If any publicly facing part of polybar is being deprecated, it should be marked as such in the code, through warnings/errors in the log, and by comments in the wiki. Every deprecated functionality is kept until the next major release and removed there, unless it has not been deprecated in a minor release before.
