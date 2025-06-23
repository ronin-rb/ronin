# ronin-sha512 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-sha512 - Calculates SHA512 hashes

## SYNOPSIS

`ronin sha512` [*options*] [*FILE* ...]

## DESCRIPTION

Calculates SHA512 hashes of data.

## ARGUMENTS

*FILE*
: The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
: Optional file to process.

`-s`, `--string` *STRING*
: Optional string to process.

`-M`, `--multiline`
: Process each line of input separately.

`-n`, `--keep-newlines`
: Preserves newlines at the end of each line.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-md5](ronin-md5.1.md) [ronin-sha1](ronin-sha1.1.md) [ronin-sha256](ronin-sha256.1.md)
