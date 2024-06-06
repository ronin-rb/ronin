# ronin-encrypt 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-encrypt - Encrypts data

## SYNOPSIS

`ronin encrypt` [*options*] [*FILE* ...]

## DESCRIPTION

Encrypts data.

## ARGUMENTS

*FILE*
: The optional file to read and encrypt. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-k`, `--key` *STRING*
: The raw key string for the cipher.

`-K`, `--key-file` *FILE*
: Reads the key string from the file.

`-c`, `--cipher` *NAME*
: The cipher to encrypt with. See `--list-ciphers` for a list of supported
  ciphers. Default to `aes-256-cbc` if not given.

`-P`, `--password` *PASSWORD*
: The password to encrypt with.

`-H`, `--hash` `md5`\|`sha1`\|`sha256`\|`sha512`
: The hash algorithm to use for the password. Default to `sha256` if not given.

`--iv` *STRING*
: Sets the Initial Vector (IV) value of the cipher.

`--padding` *NUM*
: Sets the padding size, in bytes, of the encryption cipher.

`-b`, `--block-size` *NUM*
: The size, in bytes, to read data in. Default to `16384` if not given.

`--list-ciphers`
: List the supported ciphers and exits.

`-h`, `--help`
: Print help information.

## EXAMPLES

Encrypt a file using AES-256 (CBC mode) with a password:

    $ ronin encrypt --cipher aes-256-cbc --password "..." file.txt > encrypted.bin

Encrypt a file using a raw key string:

    $ ronin encrypt --cipher aes-256-cbc --key "12345abcdef..." file.txt > encrypted.bin

Encrypt a file using a raw key read from a file:

    $ ronin encrypt --cipher aes-256-cbc --key-file key.bin file.txt > encrypted.bin

Specifying a custom IV (initialization vector):

    $ ronin encrypt --cipher aes-256-cbc --key "..." --iv "..." file.txt > encrypted.bin

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-decrypt](ronin-decrypt.1.md)
