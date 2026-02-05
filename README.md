# homebrew-enva

Homebrew tap for [enva](https://github.com/swipentap/enva) — CLI for lab deployment (K3s, LXC, HAProxy, ArgoCD).

## Install

One-time: add the tap. Then install like any other formula:

```bash
brew tap swipentap/enva
brew install enva
```

After the tap is added, `brew install enva` and `brew upgrade enva` work as usual.

To install from main (development) instead of the release binary:

```bash
brew tap swipentap/enva
brew install --HEAD enva
```

**Binaries:** By default the formula builds from source (main). To publish a release and switch the formula to pre-built binaries: push a tag (e.g. `v0.0.1`). The Release workflow builds macOS arm64/amd64 binaries, creates the GitHub Release, and updates this formula with the correct sha256. Add repo secret `HOMEBREW_ENVA_REPO_TOKEN` (PAT with push access to this repo) so the workflow can push the formula update.

## Usage

```bash
enva --help
enva --config enva.yaml deploy dev
enva redeploy dev --planonly
```
