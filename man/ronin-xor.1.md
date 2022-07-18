# ronin-xor 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin xor` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

XORs each character of data with a key.

## ARGUMENTS

*STRING*
  The optional input string value to XOR. If no *STRING* values are given,
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

`-k`, `--key` *STRING*
  The XOR key String.

`-K`, `--key-file` *FILE*
  The file to read the XOR key from.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-encode(1), ronin-rot(1)
