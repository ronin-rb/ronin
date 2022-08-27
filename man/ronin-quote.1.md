# ronin-quote 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin quote` [*options*] [*FILE* ...]

## DESCRIPTION

Produces quoted a string for a variety of programming languages.

## ARGUMENTS

*FILE*
  The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to process.

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
