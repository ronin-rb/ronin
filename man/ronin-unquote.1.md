# ronin-unquote 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin unquote` [*options*] [*FILE* ...]

## DESCRIPTION

Unquotes a double/single quoted string.

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
  Process each line separately.

`-n`, `--keep-newlines`
  Preserves newlines at the end of each line.

`-X`, `--hex`
  Unquotes the Hex string.

`-c`, `--c`
  Unquotes the C string.

`-j`, `--js`
  Unquotes the JavaScript String.

`-S`, `--shell`
  Unquotes the Shell string.

`-P`, `--powershell`
  Unquotes the PowerShell String.

`-R`, `--ruby`
  Unquotes the Ruby String.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-quote(1)
