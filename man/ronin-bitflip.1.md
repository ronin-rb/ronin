# ronin-bitflip 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin bitflip` [*options*] [*STRING* ...]

## DESCRIPTION

Prints every bit-flip of the given string(s).

## ARGUMENTS

*STRING*
  A string value to print all of the bit-flips of.

## OPTIONS

`-N`, `--numeric`
  Searches for numeric characters (0-9).

`-O`, `--octal`
  Searches for octal characters (0-7).
`-X`, `--upper-hex`
  Searches for uppercase hexadecimal (0-9, A-F).

`-x`, `--lower-hex`
  Searches for lowercase hexadecimal (0-9, a-f).

`-H`, `--hex`
  Searches for hexadecimal chars (0-9, a-f, A-F).

`--upper-alpha`
  Searches for uppercase alpha chars (A-Z).

`--lower-alpha`
  Searches for lowercase alpha chars (a-z).

`-A`, `--alpha`
  Searches for alpha chars (a-z, A-Z).

`--alpha-num`
  Searches for alpha-numeric chars (a-z, A-Z, 0-9).

`-P`, `--punct`
  Searches for punctuation chars.

`-S`, `--symbols`
  Searches for symbolic chars.

`-s`, `--space`
  Searches for all whitespace chars.

`-v`, `--visible`
  Searches for all visible chars.

`-p`, `--printable`
  Searches for all printable chars.

`-C`, `--control`
  Searches for all control chars (\x00-\x1f, \x7f).

`-a`, `--signed-ascii`
  Searches for all signed ASCII chars (\x00-\x7f).

`--ascii`
  Searches for all ASCII chars (\x00-\xff).

`-c`, `--chars` *CHARS*
  Searches for all chars in the custom char-set.

`-i`, `--include-chars` *CHARS*
  Include the additional chars to the char-set.

`-e`, `--exclude-chars` *CHARS*
  Exclude the additional chars from the char-set.

`--prepend` *STRING*
  Prepends another *STRING* to each bit-flipped value.

`--append` *STRING*
  Appends another *STRING* to each bit-flipped value.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-typo(1) ronin-homoglyph(1)
