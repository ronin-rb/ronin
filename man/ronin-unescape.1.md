# ronin-unescape 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin unescape` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

## ARGUMENTS

*STRING*
  The optional string value to unescape. If no *STRING* values are given,
  input will be read from `-i`,`--input` *FILE* or from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`-o`, `--output` *FILE*
  Optional output file to write unescaped strings to.

`-M`, `--multiline`
  Process each line separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-c`, `--c`
  Unescapes the data as a C string.

`-X`, `--hex`
  Unescapes the data as a hex string (ex: "ABC\x01\x02\x03...")

`-H`, `--html`
  HTML unescapes the data.

`-u`, `--uri`
  URI unescapes the data.

`--http`
  HTTP unescapes the data.

`-j`, `--js`
  JavaScript unescapes the data.

`-S`, `--shell`
  Unescapes the data as a Shell String.

`-P`, `--powershell`
  Unescapes the data as a PowerShell String.

`-x`, `--xml`
  XML unescapes the data.

`-s`, `--string`
  Unescapes the data as a Ruby String.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-escape(1)
