# ronin-encode 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-encode - Encodes each character of data into a variety of encodings

## SYNOPSIS

`ronin encode ` [*options*] [*FILE* ...]

## DESCRIPTION

Encodes each character of the given data into a variety of formats.

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
: Base16 encodes the data.

`--base32`
: Base32 encodes the data.

`-b`, `--base64`[`=`*strict*\|*url*]
: Base64 encodes the data. If the `strict` or `url` option value is given,
  it will enable `strict` or `url` Base64 encoding mode, respectively.

`-z`, `--zlib`
: Zlib compresses the data.

`-g`, `--gzip`
: gzip compresses the data.

`-c`, `--c`
: Encodes the data as a C string.

`-X`, `--hex`
: Hex encode the data (ex: `414141...`).

`-H`, `--html`
: HTML encodes the data.

`-u`, `--uri`
: URI encodes the data.

`--http`
: HTTP encodes the data.

`-J`, `--java`
: Encodes the data as a Java string.

`-j`, `--js`
: Encodes the data as a JavaScript string.

`-n`, `--nodejs`
: Encodes the data as a Node.js string.

`-S`, `--shell`
: Encodes the data as a Shell string.

`-P`, `--powershell`
: Encodes the data as a PowerShell string.

`--punycode`
: Encodes the data as Punycode.

`-Q`, `--quoted-printable`
: Decodes the data as Quoted Printable.

`--smtp`
: Alias for `--quoted-printable`.

`--uuencode`
: uuencodes the data.

`--perl`
: Encodes the data as a Perl string.

`-p`, `--php`
: Encodes the data as a PHP string.

`--python`
: Encodes the data as a Python string.

`-R`, `--ruby`
: Encodes the data as a Ruby string.

`-x`, `--xml`
: XML encodes the data.

`-h`, `--help`
: Print help information.

## EXAMPLES

Encode the string `"hello world"` to Base64:

        $ ronin encode --base64 --string "hello world"
        aGVsbG8gd29ybGQ=

Encode the string `"hello world"` to HTTP encoded characters:

        $ ronin encode --http --string "hello world"
        %68%65%6C%6C%6F%20%77%6F%72%6C%64

Encode the string `"hello world"` to XML encoded characters:

        $ ronin encode --xml --string "hello world"
        &#104;&#101;&#108;&#108;&#111;&#32;&#119;&#111;&#114;&#108;&#100;

Hex encodes the contents of a file:

        ronin encode --hex --file /path/to/file.txt

Hex encodes every line of a file:

        ronin encode --hex --multiline --file /path/to/file.txt

Compresses the file's contents using Zlib and then Base64 encodes it:

        ronin encode --zlib --base64 --file hi.txt

Encode the string `"hello world"` to a Ruby hex-escaped string:

        $ ronin encode --ruby --string "hello world"
        \x68\x65\x6C\x6C\x6F\x20\x77\x6F\x72\x6C\x64

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-decode](ronin-decode.1.md)
