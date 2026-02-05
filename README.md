# homebrew-enva

Homebrew tap for [enva](https://github.com/swipentap/enva) — CLI for lab deployment (K3s, LXC, HAProxy, ArgoCD).

## Install

```bash
brew tap swipentap/enva
brew install enva
```

Or install from HEAD (main branch):

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
