# ZSH Ultimate Universal Config
A fast, clean, production-ready ZSH configuration for **all Linux distributions**.

Designed for speed, usability, and cross-distro compatibility with zero bloat.

## ✨ Features
- Blazing fast startup with async module loading
- Clean minimal prompt with path, exit code, and clock
- 24-line history search when pressing **UP**
- Real-time auto-completion & syntax highlighting
- **Auto-install missing commands** (cross-distro support)
- fzf fuzzy history search (Ctrl+R)
- zoxide quick directory jump
- Universal archive extract function
- Colored man pages
- Works on Arch, Debian, Ubuntu, Fedora, RHEL, openSUSE
- Full English comments, clean structure

## Supported Distributions
- Arch Linux / Manjaro
- Debian / Ubuntu / Linux Mint
- Fedora / RHEL / CentOS
- openSUSE

## 🚀 Installation

### 1. Install Dependencies
```bash
# Debian / Ubuntu / Mint
sudo apt update && sudo apt install zsh git fzf zoxide zsh-autocomplete zsh-syntax-highlighting

# Arch / Manjaro
sudo pacman -S zsh git fzf zoxide pkgfile zsh-autocomplete zsh-syntax-highlighting

# Fedora / RHEL
sudo dnf install zsh git fzf zoxide zsh-autocomplete zsh-syntax-highlighting

# openSUSE
sudo zypper install zsh git fzf zoxide zsh-autocomplete zsh-syntax-highlighting
```

### 2. Set ZSH as Default Shell
```bash
chsh -s $(which zsh)
```

### 3. Apply Configuration
```bash
# Copy .zshrc to your home directory
cp zshrc ~/.zshrc

# Reload ZSH
source ~/.zshrc
```

## 🔧 Auto Install Missing Commands
When you run a command that is not installed:
1. First tries to install a package with the **same name**
2. If not found, automatically searches for the provider package
3. Asks to install with one keypress

Works automatically across all supported distros.

## ⌨️ Key Bindings
- `UP` / `DOWN` – Browse history with 24-line menu
- `Ctrl+R` – Fuzzy history search via fzf
- `Ctrl+Left/Right` – Jump between words
- `Ctrl+H` – Delete word backward
- `Tab` – Smart completion menu
- `extract <file>` – Unpack any archive

## 📌 Useful Aliases
- `ll`, `la`, `lh` – Enhanced directory listing
- `extract` – Universal archive extractor
- `gitu` – git add . && commit && push
- `df`, `free` – Human-readable system info

## Customization
- Change history lines: `zstyle ':autocomplete:*' list-lines 24`
- Modify prompt appearance: edit `PROMPT` / `RPROMPT`
- Add your own aliases in the Aliases section

## License
MIT
```
