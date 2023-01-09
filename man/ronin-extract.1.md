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
  Searches for all numbers.

`-X`, `--hex-number`
  Searches for all hexadecimal numbers.

`-V`, `--version-number`
  Searches for all version numbers.

`-w`, `--word`
  Searches for all words.

`--mac-addr`
  Searches for all MAC addresses.

`-4`, `--ipv4-addr`
  Searches for all IPv4 addresses.

`-6`, `--ipv6-addr`
  Searches for all IPv6 addresses.

`-I`, `--ip`
  Searches for all IP addresses.

`-H`, `--host`
  Searches for all host names.

`-D`, `--domain`
  Searches for all domain names.

`--uri`
  Searches for all URIs.

`-U`, `--url`
  Searches for all URLs.

`--user-name`
  Searches for all user names.

`-E`, `--email-addr`
  Searches for all email addresses.

`--obfuscated-email-addr`
  Searches for all obfuscated email addresses.

`--phone-number`
  Searches for all phone numbers.

`--ssn`
  Searches for all Social Security Numbers (SSNs).

`--amex-cc`
  Searches for all AMEX Credit Card numbers.

`--discover-cc`
  Searches for all Discover Card numbers.

`--mastercard-cc`
  Searches for all MasterCard numbers.

`--visa-cc`
  Searches for all VISA Credit Card numbers.

`--visa-mastercard-cc`
  Searches for all VISA MasterCard numbers.

`--cc`
  Searches for all Credit Card numbers.

`--file-name`
  Searches for all file names.

`--dir-name`
  Searches for all directory names.

`--relative-unix-path`
  Searches for all relative UNIX paths.

`--absolute-unix-path`
  Searches for all absolute UNIX paths.

`--unix-path`
  Searches for all UNIX paths.

`--relative-windows-path`
  Searches for all relative Windows paths.

`--absolute-windows-path`
  Searches for all absolute Windows paths.

`--windows-path`
  Searches for all Windows paths.

`--relative-path`
  Searches for all relative paths.

`--absolute-path`
  Searches for all absolute paths.

`-P`, `--path`
  Searches for all paths.

`--identifier`
  Searches for all identifier names.

`--variable-name`
  Searches for all variable names.

`--variable-assignment`
  Searches for all variable assignments.

`--function-name`
  Searches for all function names.

`--md5`
  Searches for all MD5 hashes.

`--sha1`
  Searches for all SHA1 hashes.

`--sha256`
  Searches for all SHA256 hashes.

`--sha512`
  Searches for all SHA512 hashes.

`--hash`
  Searches for all hashes.

`--ssh-private-key`
  Searches for all SSH private key data.

`--dsa-private-key`
  Searches for all DSA private key data.

`--ec-private-key`
  Searches for all EC private key data.

`--rsa-private-key`
  Searches for all RSA private key data.

`-K`, `--private-key`
  Searches for all private key data.

`--ssh-public-key`
  Searches for all SSH public key data.

`--public-key`
  Searches for all public key data.

`--aws-access-key-id`
  Searches for all AWS access key IDs.

`--aws-secret-access-key`
  Searches for all AWS secret access key.

`-A`, `--api-key`
  Searches for all API keys (MD5, SHA1, SHA256, SHA512, AWS access key ID, or
  AWS secret access key).

`--single-quoted-string`
  Searches for all single-quoted strings.

`--double-quoted-string`
  Searches for all double-quoted strings.

`-S`, `--string`
  Searches for all quoted strings.

`-B`, `--base64`
  Searches for all Base64 strings.

`--c-comment`
  Searches for all C comments.

`--cpp-comment`
  Searches for all C++ comments.

`--java-comment`
  Searches for all Java comments.

`--javascript-comment`
  Searches for all JavaScript comments.

`--shell-comment`
  Searches for all Shell comments.

`--ruby-comment`
  Searches for all Ruby comments.

`--python-comment`
  Searches for all Python comments.

`--comment`
  Searches for all comments.

`-e`, `--regexp` /*REGEXP*/
  Custom regular expression to search for.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-grep(1)
