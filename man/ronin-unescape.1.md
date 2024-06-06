# ronin-unescape 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-unescape - Unescapes each escaped character from a variety of encodings

## SYNOPSIS

`ronin unescape` [*options*] [*FILE* ...]

## DESCRIPTION

Unescapes each escaped character from a variety of encodings.

## ARGUMENTS

*FILE*
: The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file ` *FILE*
: Optional file to process.

`--string` *STRING*
: Optional string to process.

`-M`, `--multiline`
: Process each line separately.

`-n`, `--keep-newlines`
: Preserves newlines at the end of each line.

`-c`, `--c`
: Unescapes the data as a C string.

`-X`, `--hex`
: Unescapes the data as a hex string (ex: "ABC\x01\x02\x03...")

`-H`, `--html`
: HTML unescapes the data.

`-u`, `--uri`
: URI unescapes the data.

`--http`
: HTTP unescapes the data.

`-j`, `--js`
: JavaScript unescapes the data.

`-S`, `--shell`
: Unescapes the data as a Shell String.

`-P`, `--powershell`
: Unescapes the data as a PowerShell String.

`-Q`, `--quoted-printable`
: Unescapes the data as Quoted Printable.

`-R`, `--ruby`
: Unescapes the data as a Ruby String.

`-x`, `--xml`
: XML unescapes the data.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-escape](ronin-escape.1.md)