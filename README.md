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

**Release:** Push tag (e.g. `v0.0.1`). Release workflow builds binaries, creates the GitHub Release, and updates this formula with sha256. Add repo secret `HOMEBREW_ENVA_REPO_TOKEN` (push to this repo) in the enva repo.

## Usage

```bash
enva --help
enva --config enva.yaml deploy dev
enva redeploy dev --planonly
```
