# ronin-decode 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin decode ` [*options*] [*FILE* ...]

## DESCRIPTION

Decodes each character of the given data from a variety of formats.

## ARGUMENTS

*FILE*
  The optional file to read and process. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to process.

`--string` *STRING*
  Optional string to process.

`-M`, `--multiline`
  Process each line of input separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`--base32`
  Base32 decodes the data.

`-b`, `--base64`[`=`*strict*\|*url*]
  Base64 decodes the data. If the `strict` or `url` option value is given,
  it will enable `strict` or `url` Base64 encoding mode, respectively.

`-c, `--c`
  Decodes the data as a C string.

`-X`, `--hex`
  Hex decode the data (ex: `414141...`).

`-H`, `--html`
  HTML decodes the data.

`-u`, `--uri`
  URI decodes the data.

`--http`
  HTTP decodes the data.

`-j`, `--js`
  JavaScript decodes the data.

`-S`, `--shell`
  Decodes the data as a Shell String.

`-P`, `--powershell`
  Decodes the data as a PowerShell String.

`-x`, `--xml`
  XML decodes the data.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-encode(1)
