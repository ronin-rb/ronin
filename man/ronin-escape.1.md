# ronin-escape 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-escape - Escapes each special character for a variety of encodings

## SYNOPSIS

`ronin escape` [*options*] [*FILE* ...]

## DESCRIPTION

Escapes each special character for a variety of encodings.

## ARGUMENTS

*FILE*
: The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
: Optional input file to read from.

`--string` *STRING*
: Optional string to process.

`-M`, `--multiline`
: Process each line separately.

`-n`, `--keep-newlines`
: Preserves newlines at the end of each line.

`-c`, `--c`
: Escapes the data as a C string.

`-X`, `--hex`
: Escapes the data as a hex string (ex: "ABC\x01\x02\x03...")

`-H`, `--html`
: HTML escapes the data.

`-u`, `--uri`
: URI escapes the data.

`--http`
: HTTP escapes the data.

`-j`, `--js`
: JavaScript escapes the data.

`-S`, `--shell`
: Escapes the data as a Shell String.

`-P`, `--powershell`
: Escapes the data as a PowerShell String.

`-Q`, `--quoted-printable`
: Escapes the data as Quoted Printable.

`-R`, `--ruby`
: Escapes the data as a Ruby String.

`-x`, `--xml`
: XML escapes the data.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-unescape](ronin-unescape.1.md)