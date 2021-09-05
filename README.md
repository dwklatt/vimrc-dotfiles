# Dotfiles


## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails.

## Install

### Fonts
Emacs uses 3 fonts not installed by default. Menlo, Liga SF Mono (nerd font) and SF Pro. Although homebrew should handle the installation process, you can reinstall them if nessecary

You will have to manually install the otf files from ~/fonts

On linux, you will have to install 3 fonts
1. Fira SFMono Nerd Font (https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized)
2. SF Pro
3. IBM Plex Sans


### Emacs

My emacs configuration is designed for org-mode editing, as well as moderate programming use.

If you want to recompile the literate configuration, you can run

```zsh
doom sync -u
```

If you want to update the doom configuration, you can run

```zsh
doom upgrade
```

If you modify your shell configuration, run `doom env` to regenerate env vars

You may get errors due to missing fonts on linux. In which case either switch the fonts to what you need, or use DejaVu fonts:
```lisp
;;fonts
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 14 :weight 'light)
      doom-big-font (font-spec :family "DejaVu Sans Mono" :size 20 :weight 'light)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 16 :weight 'Medium)
      doom-unicode-font (font-spec :family "DejaVu Sans Mono":weight 'light)
      doom-serif-font (font-spec :family "DejaVu Sans Mono" :weight 'Regular))
```

(and adjust the serif writeroom font, from SF Pro to DejaVu Sans)

### Neovim

My neovim configuration is designed for programming and quick text editing. As such, it opens in under 10ms.

Upon starting Neovim, packer should automatically install and sync. In case this step fails, or you want to update plugins, you can run `:PackerSync`

The plugins will install. After restarting neovim, nvim-treesitter should install and configure parsers. Afterwards. run `:checkhealth` to check for possible issues.

If you modify the configuration files for certain plugins, you may have to run `:PackerSync` to apply changes

If you want to take advantage of the LSP, you can install language servers using the following command:

`:LspInstall (language)` e.g. `:LspInstall java` to install the java LSP (jdtls)

I also recommend installing [Neovide](https://github.com/Kethku/neovide) or [goneovim](https://github.com/akiyosi/goneovim) if you prefer a gui experience. A goneovim config is included in the dotfiles

## Feedback

Suggestions/improvements
[welcome](https://github.com/shaunsingh/vimrc-dotfiles/issues)!
