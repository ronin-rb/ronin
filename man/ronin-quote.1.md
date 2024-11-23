# ronin-quote 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-quote - Produces quoted a string for a variety of programming languages

## SYNOPSIS

`ronin quote` [*options*] [*FILE* ...]

## DESCRIPTION

Produces quoted a string for a variety of programming languages.

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
: Process each line separately.

`-n`, `--keep-newlines`
: Preserves newlines at the end of each line.

`-X`, `--hex`
: Quotes the data as a Hex string.

`-c`, `--c`
: Quotes the data as a C string.

`-j`, `--js`
: Quotes the data as a JavaScript string.

`-S`, `--shell`
: Quotes the data as a Shell string.

`-P`, `--powershell`
: Quotes the data as a PowerShell string.

`--perl`
: Quotes the data as a Perl string.

`-p`, `--php`
: Quotes the data as a PHP string.

`--python`
: Quotes the data as a Python string.

`-R`, `--ruby`
: Quotes the data as a Ruby string.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-unquote](ronin-unquote.1.md)
