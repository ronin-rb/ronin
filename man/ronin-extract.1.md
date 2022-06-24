# ronin-extract 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin extract` [*options*] [*FILE* ...]

## DESCRIPTION

Extract common patterns in the given file(s) or input stream.

## ARGUMENTS

*FILE*
  The optional file to extract. If no *FILE* arguments are given, then
  `ronin extract` will read from standard input.

## OPTIONS

`-N`, `--number`
  Extract all numbers.

`-X`, `--hex-number`
  Extract all numbers.

`-w`, `--word`
  Extract all words.

`--mac-addr`
  Extract all MAC addresses.

`-4`, `--ipv4-addr`
  Extract all IPv4 addresses.

`-6`, `--ipv6-addr`
  Extract all IPv6 addresses.

`-I`, `--ip`
  Extract all IP addresses.

`-H`, `--host`
  Extract all host names.

`-D`, `--domain`
  Extract all domain names.

`-U`, `--url`
  Extract all URLs.

`--user-name`
  Extract all user names.

`-E`, `--email-addr`
  Extract all email addresses.

`--obfuscated-email-addr`
  Extract all obfuscated email addresses.

`--phone-number`
  Extract all phone numbers.

`--ssn`
  Extract all Social Security Numbers (SSNs).

`--amex-cc`
  Extract all AMEX Credit Card numbers.

`--discover-cc`
  Extract all Discord Card numbers.

`--mastercard-cc`
  Extract all MasterCard numbers.

`--visa-cc`
  Extract all VISA Credit Card numbers.

`--visa-mastercard-cc`
  Extract all VISA MasterCard numbers.

`--cc`
  Extract all Credit Card numbers.

`--file-name`
  Extract all file names.

`--dir-name`
  Extract all directory names.

`--relative-unix-path`
  Extract all relative UNIX paths.

`--absolute-unix-path`
  Extract all absolute UNIX paths.

`--unix-path`
  Extract all UNIX paths.

`--relative-windows-path`
  Extract all relative Windows paths.

`--absolute-windows-path`
  Extract all absolute Windows paths.

`--windows-path`
  Extract all Windows paths.

`--relative-path`
  Extract all relative paths.

`--absolute-path`
  Extract all absolute paths.

`-P`, `--path`
  Extract all paths.

`--variable-name`
  Extract all variable names.

`--function-name`
  Extract all function names.

`--md5`
  Extract all MD5 hashes.

`--sha1`
  Extract all SHA1 hashes.

`--sha256`
  Extract all SHA256 hashes.

`--sha512`
  Extract all SHA512 hashes.

`--hash`
  Extract all hashes.

`--ssh-private-key`
  Extract all SSH private key data.

`--ssh-public-key`
  Extract all SSH public key data.

`--private-key`
  Extract all private key data.

`--rsa-public-key`
  Extract all RSA public key data.

`--dsa-public-key`
  Extract all DSA public key data.

`--ec-public-key`
  Extract all EC public key data.

`--public-key`
  Extract all public key data.

`--single-quoted-string`
  Extract all single-quoted strings.

`--double-quoted-string`
  Extract all double-quoted strings.

`-S`, `--string`
  Extract all quoted strings.

`-B`, `--base64`
  Extract all Base64 strings.

`-e`, `--regexp` /*REGEXP*/
  Custom regular expression to search for.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-grep(1)
