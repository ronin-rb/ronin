# ronin-xor 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin xor` [*options*] [*FILE* ...]

## DESCRIPTION

XORs each character of data with a key.

## ARGUMENTS

*FILE*
  The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to process.

`--string` *STRING*
  Optional string to process.

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
