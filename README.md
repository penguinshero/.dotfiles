# .dotfiles

Personal Linux configuration files for a clean, consistent, and reproducible development environment.

## Overview

This repository contains my personal dotfiles and shell configurations. The goal is to keep my Linux environment organized, portable, and easy to restore across systems.

## Structure

```text
.dotfiles/
├── gcm/
│   └── .gitconfig
├── hushlogin/
│   └── .hushlogin
├── kitty/
│   └── .config/
│       └── kitty/
│           ├── colors.conf
│           ├── fonts.conf
│           ├── keymaps.conf
│           ├── kitty.conf
│           └── window.conf
├── zen/
│   ├── container
│   ├── htb
│   └── pentest
└── zsh/
    └── .zshrc
```

## Components

### Zsh

My main Zsh configuration, including:

* Shell options
* History management
* Completion
* Autosuggestions
* FZF integration
* Zoxide
* Eza and Bat
* Custom aliases
* Navigation helpers
* Network utilities
* Python and Go environment helpers
* Custom shell functions
* `zen` profile loader

### Zen

**ZEN — Zsh Extension Node**

A small modular profile loader for enabling and disabling groups of Zsh configuration dynamically.

Available profiles:

```text
container
htb
pentest
```

Usage:

```bash
zen list
zen load <profile>
zen unload <profile>
```

### Kitty

Modular Kitty terminal configuration split into separate files:

* `colors.conf` — terminal color scheme
* `fonts.conf` — font configuration
* `keymaps.conf` — keyboard shortcuts and window/tab navigation
* `window.conf` — window, tab, cursor, and appearance settings
* `kitty.conf` — main configuration entry point

### Hushlogin

Contains `.hushlogin` to suppress login-shell messages.

### Git Credential Manager

Contains my Git Credential Manager configuration using the system Secret Service credential store.

## Philosophy

These configurations are intentionally modular and focused on:

* **Simplicity** — avoid unnecessary configuration
* **Portability** — prefer `$HOME` and environment variables over hard-coded paths
* **Modularity** — keep independent configurations separated
* **Reproducibility** — make rebuilding my environment straightforward
* **Maintainability** — keep configurations readable and easy to modify

## Notes

This repository is primarily intended for my personal Linux environment. Some configurations may depend on specific tools or packages being installed.

Examples include:

* Zsh
* Kitty
* FZF
* Zoxide
* Eza
* Bat
* Ripgrep
* Nerd Fonts
* Git Credential Manager

---

*Personal Linux environment, version controlled.*

