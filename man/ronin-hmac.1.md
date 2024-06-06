# ronin-hmac 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-hmac - Calculates a Hash-based Message Authentication Code (HMAC)

## SYNOPSIS

`ronin hmac` [*options*] [*FILE* ...]

## DESCRIPTION

Calculates a Hash-based Message Authentication Code (HMAC) for data.

## ARGUMENTS

*FILE*
: The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
: Optional file to process.

`--string` *STRING*
: Optional string to process.

`-M`, `--multiline`
: Process each line of input separately.

`-n`, `--keep-newlines`
: Preserves newlines at the end of each line.

`-H`,`--hash` `md5`\|`sha1`\|`sha256`\|`sha512`
: Hash algorithm to use. Defaults to `sha1` if the option is not given.

`-k`, `--key` *KEY*
: The key string to use.

`-k`, `--key-file` *FILE*
: The file to read the key string from.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-md5](ronin-md5.1.md) [ronin-sha1](ronin-sha1.1.md) [ronin-sha256](ronin-sha256.1.md) [ronin-sha512](ronin-sha512.1.md)