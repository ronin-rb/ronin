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

`-s`, `--string` *STRING*
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

`-J`, `--java`
: Escapes the data as a Java string.

`-j`, `--js`
: Escapes the data as a JavaScript string.

`-n`, `--nodejs`
: Escapes the data as a Node.js string.

`-S`, `--shell`
: Escapes the data as a Shell string.

`-P`, `--powershell`
: Escapes the data as a PowerShell string.

`-Q`, `--quoted-printable`
: Escapes the data as Quoted Printable.

`--smtp`
: Alias for `--quoted-printable`.

`--perl`
: Escapes the data as a Perl string.

`-p`, `--php`
: Escapes the data as a PHP string.

`--python`
: Escapes the data as a Python string.

`-R`, `--ruby`
: Escapes the data as a Ruby string.

`-x`, `--xml`
: XML escapes the data.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-unescape](ronin-unescape.1.md)
