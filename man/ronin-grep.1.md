# ronin-grep 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin grep` [*options*] [*FILE* ...]

## DESCRIPTION

Greps for common patterns in the given file(s) or input stream.

## ARGUMENTS

*FILE*
  The optional file to grep. If no *FILE* arguments are given, then
  `ronin grep` will read from standard input.

## OPTIONS

`-N`, `--number`
  Grep for all numbers.

`-X`, `--hex-number`
  Grep for all numbers.

`-w`, `--word`
  Grep for all words.

`--mac-addr`
  Grep for all MAC addresses.

`-4`, `--ipv4-addr`
  Grep for all IPv4 addresses.

`-6`, `--ipv6-addr`
  Grep for all IPv6 addresses.

`-I`, `--ip`
  Grep for all IP addresses.

`-H`, `--host`
  Grep for all host names.

`-D`, `--domain`
  Grep for all domain names.

`-U`, `--url`
  Grep for all URLs.

`--user-name`
  Grep for all user names.

`-E`, `--email-addr`
  Grep for all email addresses.

`--phone-number`
  Grep for all phone numbers.

`--ssn`
  Grep for all Social Security Numbers (SSNs).

`--file-name`
  Grep for all file names.

`--dir-name`
  Grep for all directory names.

`--relative-unix-path`
  Grep for all relative UNIX paths.

`--absolute-unix-path`
  Grep for all absolute UNIX paths.

`--unix-path`
  Grep for all UNIX paths.

`--relative-windows-path`
  Grep for all relative Windows paths.

`--absolute-windows-path`
  Grep for all absolute Windows paths.

`--windows-path`
  Grep for all Windows paths.

`--relative-path`
  Grep for all relative paths.

`--absolute-path`
  Grep for all absolute paths.

`-P`, `--path`
  Grep for all paths.

`--variable-name`
  Grep for all variable names.

`--function-name`
  Grep for all function names.

`--md5`
  Grep for all MD5 hashes.

`--sha1`
  Grep for all SHA1 hashes.

`--sha256`
  Grep for all SHA256 hashes.

`--sha512`
  Grep for all SHA512 hashes.

`--hash`
  Grep for all hashes.

`--ssh-private-key`
  Grep for all SSH private key data.

`--ssh-public-key`
  Grep for all SSH public key data.

`--private-key`
  Grep for all private key data.

`--rsa-public-key`
  Grep for all RSA public key data.

`--dsa-public-key`
  Grep for all DSA public key data.

`--ec-public-key`
  Grep for all EC public key data.

`--public-key`
  Grep for all public key data.

`--single-quoted-string`
  Grep for all single-quoted strings.

`--double-quoted-string`
  Grep for all double-quoted strings.

`-S`, `--string`
  Grep for all quoted strings.

`-B`, `--base64`
  Grep for all Base64 strings.

`-e`, `--regexp` /*REGEXP*/
  Custom regular expression to search for.

`-o`, `--only-matching`
  Only print the matching data.

`-n`, `--line-number`
  Print the line number for each line.

`--with-filename`
  Print the file name for each match.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-extract(1)
