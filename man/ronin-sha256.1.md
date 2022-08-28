# ronin-sha256 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin sha256` [*options*] [*FILE* ...]

## DESCRIPTION

Calculates SHA256 hashes of data.

## ARGUMENTS

*FILE*
  The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`--string` *STRING*
  Optional string to process.

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
