# ronin-rot 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin rot` [*options*] [*FILE* ...]

## DESCRIPTION

Rotates each character of data with an alphabet.

## ARGUMENTS

*FILE*
  The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to process.

`-M`, `--multiline`
  Process each line of input separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-A`, `--alphabet` `ABC...`
  Alphabet characters to rotate characters within.

`-n`, `--modulu` *NUM*
  Number of characters to rotate forwards or backwards.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-encode(1), ronin-rot(1)
