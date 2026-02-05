# homebrew-enva

Homebrew tap for [enva](https://github.com/swipentap/enva) — CLI for lab deployment (K3s, LXC, HAProxy, ArgoCD).

## Install

One-time: add the tap. Then install like any other formula:

```bash
brew tap swipentap/enva
brew install enva
```

After the tap is added, `brew install enva` and `brew upgrade enva` work as usual.

To install from main (development) instead of the stable tarball:

```bash
brew tap swipentap/enva
brew install --HEAD enva
```

## Usage

```bash
enva --help
enva --config enva.yaml deploy dev
enva redeploy dev --planonly
```
