# ronin-quote 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin quote` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

Produces quoted a string for a variety of programming languages.

## ARGUMENTS

*STRING*
  The optional string value to quote. If no *STRING* values are given,
  input will be read from `-i`,`--input` *FILE* or from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`-o`, `--output` *FILE*
  Optional output file to write quoted strings to.

`-M`, `--multiline`
  Process each line separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-c`, `--c`
  Quotes the data as a C string.

`-j`, `--js`
  JavaScript quotes the data.

`-S`, `--shell`
  Quotes the data as a Shell String.

`-P`, `--powershell`
  Quotes the data as a PowerShell String.

`-s`, `--string`
  Quotes the data as a Ruby String.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-unquote(1)
