# ronin-completion 1 "2024-01-01" Ronin "User Manuals"

## NAME

ronin-completion - Manages shell completion rules for `ronin`

## SYNOPSIS

`ronin completion` [*options*]

## DESCRIPTION

The `ronin completion` command can print, install, or uninstall shell
completion rules for the `ronin` command and all other `ronin-*` commands.

Supports installing completion rules for Bash or Zsh shells.
Completion rules for the Fish shell is currently not supported.

### ZSH SUPPORT

Zsh users will have to add the following lines to their `~/.zshrc` file in
order to enable Zsh's Bash completion compatibility layer:

    autoload -Uz +X compinit && compinit
    autoload -Uz +X bashcompinit && bashcompinit

## OPTIONS

`--print`
: Prints the shell completion file.

`--install`
: Installs the shell completion file.

`--uninstall`
: Uninstalls the shell completion file.

`-h`, `--help`
: Prints help information.

## ENVIRONMENT

*PREFIX*
: Specifies the root prefix for the file system.

*HOME*
: Specifies the home directory of the user. Ronin will search for the
  `~/.cache/ronin` cache directory within the home directory.

*XDG_DATA_HOME*
: Specifies the data directory to use. Defaults to `$HOME/.local/share`.

## FILES

`~/.local/share/bash-completion/completions/`
: The user-local installation directory for Bash completion files.

`/usr/local/share/bash-completion/completions/`
: The system-wide installation directory for Bash completions files.

`/usr/local/share/zsh/site-functions/`
: The installation directory for Zsh completion files.

## EXAMPLES

`ronin completion --print`
: Prints all shell completion rules instead of installing them.

`ronin completion --install`
: Installs all shell completion rules for `ronin` and the other `ronin-*`
  commands.

`ronin completion --uninstall`
: Uninstalls all shell completion rules for `ronin` and the other `ronin-*`
  commands.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

