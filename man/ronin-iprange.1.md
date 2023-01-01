# ronin-iprange 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin iprange` [*options*] [*IP_RANGE* ... \| `--start` *IP* `--stop` *IP*]

## DESCRIPTION

Enumerates over the given IP range(s). The IP range(s) can given from either
command-line arguments or read from a file via the `--file` option.

## ARGUMENTS

*IP_RANGE*
  An IP range argument given in either CIDR or glob notation.

## OPTIONS

`-f`, `--file` *FILE*
  The optional file to read values from.

`--start` *IP*
  The starting IP address for the range.

`--stop` *IP*
  The stopping IP address for the range.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

