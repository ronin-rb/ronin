# ronin-entropy 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin entropy` [*options*] [*FILE* ...]

## DESCRIPTION

Filters each line by it's Shannon Entropy.

## ARGUMENTS

*FILE*
  The optional file to read and filter. If no *FILE* arguments are given, then
  `ronin entropy` will read from standard input.

## OPTIONS

`-e`, `--entropy` DEC
  The minimum required entropy value. If the `-e`,`--entropy` option is not
  given, it will default to `4.0`.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-extract(1)
