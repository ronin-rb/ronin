# ronin-iprange 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin iprange` [*options*] {*IP_RANGE* ... \| `--start` *IP* `--stop` *IP* \| `--input` *FILE*}

## DESCRIPTION

Enumerates over the given IP range(s). The IP range(s) can given from either
command-line arguments, the `--start` and `--stop` options, or from a *FILE*
via the `--input` option.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read the IP ranges from.

`--start` *IP*
  The starting IP address for the range.

`--stop` *IP*
  The stopping IP address for the range.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

