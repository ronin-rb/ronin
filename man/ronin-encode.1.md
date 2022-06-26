# ronin-encode 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin encode ` [*options*] [*STRING* ... \| `-i` *FILE*]

## DESCRIPTION

Encodes each character of the given data into a variety of formats.

## ARGUMENTS

*STRING*
  The optional string value to encode. If no *STRING* values are given,
  input will be read from `-i`,`--input` *FILE* or from `stdin`.

## OPTIONS

`-i`, `--input` *FILE*
  Optional input file to read from.

`-o`, `--output` *FILE*
  Optional output file to write encoded values to.

`-M`, `--multiline`
  Process each line of input separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`--base32`
  Base32 encodes the data.

`-b`, `--base64`[`=`*strict*\|*url*]
  Base64 encodes the data. If the `strict` or `url` option value is given,
  it will enable `strict` or `url` Base64 encoding mode, respectively.

`-c, `--c`
  Encodes the data as a C string.

`-X`, `--hex`
  Hex encode the data (ex: `414141...`).

`-H`, `--html`
  HTML encodes the data.

`-u`, `--uri`
  URI encodes the data.

`--http`
  HTTP encodes the data.

`-j`, `--js`
  JavaScript encodes the data.

`-S`, `--shell`
  Encodes the data as a Shell String.

`-P`, `--powershell`
  Encodes the data as a PowerShell String.

`-x`, `--xml`
  XML encodes the data.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-decode(1)
