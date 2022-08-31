# ronin-typo 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin typo` [*options*] [*WORD* ...]

## DESCRIPTION

Generates typos in words.

## ARGUMENTS

*WORD*
  The optional word to typo.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to process.

`-M`, `--multiline`
  Process each line of input separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`--omit-chars`
  Toggles whether to omit repeated characters.

`--repeat-chars`
  Toggles whether to repeat single characters.

`--swap-chars`
  Toggles whether to swap certain common character pairs.

`--change-suffix`
  Toggles whether to change the suffix of words.

`-E`, `--enumerate`
  Enumerates over every possible typo of a word.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-homoglyph(1)
