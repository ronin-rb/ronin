# ronin-hmac 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin hmac` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

Calculates a Hash-based Message Authentication Code (HMAC) for data.

## ARGUMENTS

*STRING*
  The optional input string value to sign. If no *STRING* values are given,
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

`-H`,`--hash` `md5`\|`sha1`\|`sha256`\|`sha512`
  Hash algorithm to use. Defaults to `sha1` if the option is not given.

`-k`, `--key` *KEY*
  The key string to use.

`-k`, `--key-file` *FILE*
  The file to read the key string from.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-md5(1), ronin-sha1(1), ronin-sha256(1), ronin-sha512(1)
