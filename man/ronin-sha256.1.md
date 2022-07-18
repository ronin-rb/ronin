# ronin-sha256 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin sha256` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

Calculates SHA256 hashes of data.

## ARGUMENTS

*STRING*
  The optional input string value to hash. If no *STRING* values are given,
  input will be read from `-i`,`--input` *FILE* or from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`-o`, `--output` *FILE*
  Optional output file to write encoded values to.

`-M`, `--multiline`
  Process each line of input separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-md5(1), ronin-sha1(1), ronin-sha512(1)
