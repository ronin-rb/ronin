# ronin-escape 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin escape` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

## ARGUMENTS

*STRING*
  The optional string value to escape. If no *STRING* values are given,
  input will be read from `-i`,`--input` *FILE* or from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`-o`, `--output` *FILE*
  Optional output file to write escaped strings to.

`-M`, `--multiline`
  Process each line separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-c`, `--c`
  Escapes the data as a C string.

`-X`, `--hex`
  Escapes the data as a hex string (ex: "ABC\x01\x02\x03...")

`-H`, `--html`
  HTML escapes the data.

`-u`, `--uri`
  URI escapes the data.

`--http`
  HTTP escapes the data.

`-j`, `--js`
  JavaScript escapes the data.

`-S`, `--shell`
  Escapes the data as a Shell String.

`-P`, `--powershell`
  Escapes the data as a PowerShell String.

`-x`, `--xml`
  XML escapes the data.

`-s`, `--string`
  Escapes the data as a Ruby String.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-unescape(1)
