# ronin-decode 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-decode - Decodes each character of data from a variety of encodings

## SYNOPSIS

`ronin decode ` [*options*] [*FILE* ...]

## DESCRIPTION

Decodes each character of the given data from a variety of formats.

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

`--base16`
: Base16 decodes the data.

`--base32`
: Base32 decodes the data.

`-b`, `--base64`[`=`*strict*\|*url*]
: Base64 decodes the data. If the `strict` or `url` option value is given,
  it will enable `strict` or `url` Base64 encoding mode, respectively.

`-z`, `--zlib`
: Zlib uncompresses the data.

`-g`, `--gzip`
: gzip uncompresses the data.

`-c, `--c`
: Decodes the data as a C string.

`-X`, `--hex`
: Hex decode the data (ex: `414141...`).

`-H`, `--html`
: HTML decodes the data.

`-u`, `--uri`
: URI decodes the data.

`--http`
: HTTP decodes the data.

`-J`, `--java`
: Decodes the data as a Java string.

`-j`, `--js`
: JavaScript decodes the data.

`-n`, `--nodejs`
: Decodes the data as a Node.js string.

`-S`, `--shell`
: Decodes the data as a Shell string.

`-P`, `--powershell`
: Decodes the data as a PowerShell string.

`--punycode`
: Decodes the data as Punycode.

`-Q`, `--quoted-printable`
: Decodes the data as Quoted Printable.

`--smtp`
: Alias for `--quoted-printable`.

`--perl`
: Decodes the data as a Perl string.

`-p`, `--php`
: Decodes the data as a PHP string.

`--python`
: Decodes the data as a Python string.

`-R`, `--ruby`
: Decodes the data as a Ruby string.

`--uudecode`
: uudecodes the data.

`-x`, `--xml`
: XML decodes the data.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-encode](ronin-encode.1.md)
