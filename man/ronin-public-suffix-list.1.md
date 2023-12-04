# ronin-public-suffix-list 1 "2023-02-1" Ronin "User Manuals"

## SYNOPSIS

`ronin public-suffix-list` [*options*]

## DESCRIPTION

Updates and parses the public suffix list file.

## OPTIONS

`-v`, `--verbose`
: Enables verbose output.

`-u`, `--update`
: Updates the public suffix list file.

`-U`, `--url` *URL*
: The URL to the public suffix list. Defaults to
  `https://publicsuffix.org/list/public_suffix_list.dat`.

`-p`, `--path` *FILE*
: The Path to the public suffix list file. Defaults to
  `~/.cache/ronin/ronin-support/public_suffix_list.dat` if not given.

`-h`, `--help`
: Print help information

## ENVIRONMENT

*HOME*
: Alternate location for the user's home directory.

*XDG_CONFIG_HOME*
: Alternate location for the `~/.config` directory.

## FILES

`~/.cache/ronin/ronin-support/public_suffix_list.dat`
: The location of the downloaded public suffix list.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-tld-list](ronin-tld-list.1.md)