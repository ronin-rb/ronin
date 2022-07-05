# ronin-unquote 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin unquote` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

Unquotes a double/single quoted string.

## ARGUMENTS

*STRING*
  The optional string value to unquote. If no *STRING* values are given,
  input will be read from `-i`,`--input` *FILE* or from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`-o`, `--output` *FILE*
  Optional output file to write unquoted strings to.

`-M`, `--multiline`
  Process each line separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-c`, `--c`
  Unquotes the C string.

`-j`, `--js`
  Unquotes the JavaScript String.

`-S`, `--shell`
  Unquotes the Shell string.

`-P`, `--powershell`
  Unquotes the PowerShell String.

`-s`, `--string`
  Unquotes the Ruby String.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-quote(1)
