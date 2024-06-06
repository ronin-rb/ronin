# ronin-md5 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-md5 - Calculates MD5 hashes of data

## SYNOPSIS

`ronin md5` [*options*] [*FILE* ...]

## DESCRIPTION

Calculates MD5 hashes of data.

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

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-sha1](ronin-sha1.1.md) [ronin-sha256](ronin-sha256.1.md) [ronin-sha512](ronin-sha512.1.md)