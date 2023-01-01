# ronin-public-suffix-list 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin public-suffix-list` [*options*]

## DESCRIPTION

Updates and parses the public suffix list file.

## OPTIONS

`-v`, `--verbose`
  Enables verbose output.

`-u`, `--update`
  Updates the public suffix list file.

`-U`, `--url` *URL*
  The URL to the public suffix list. Defaults to
  `https://publicsuffix.org/list/public_suffix_list.dat`.

`-p`, `--path` *FILE*
  The Path to the public suffix list file. Defaults to
  `~/.cache/ronin/ronin-support/public_suffix_list.dat` if not given.

`-h`, `--help`
  Print help information

## FILES

`~/.cache/ronin/ronin-support/public_suffix_list.dat`
  The location of the downloaded public suffix list.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-tld-list(1)
