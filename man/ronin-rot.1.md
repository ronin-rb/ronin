# ronin-rot 1 "2023-02-01" Ronin "User Manuals"

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

`--string` *STRING*
  Optional string to process.

`-M`, `--multiline`
  Process each line of input separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-A`, `--alphabet` `ABC...`
  Alphabet characters to rotate characters within.

`-n`, `--modulo` *NUM*
  Number of characters to rotate forwards or backwards. Defaults to 13 if not
  given.

`-h`, `--help`
  Print help information.

## EXAMPLES

ROT-13 encode a string:

        $ ronin rot --string "The quick brown fox jumps over the lazy dog"

ROT encode a string with a custom rotation number:

        $ ronin rot -n 3 --string "The quick brown fox jumps over the lazy dog"

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-encode(1), ronin-rot(1)
