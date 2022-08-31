# ronin-decrypt 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin decrypt` [*options*] [*FILE* ...]

## DESCRIPTION

Encrypts data.

## ARGUMENTS

*FILE*
  The optional file to read and decrypt. If no *FILE* arguments are given,
  input will be read from `stdin`.

## OPTIONS

`-k`, `--key` *STRING*
  The raw key string for the cipher.

`-K`, `--key-file` *FILE*
  Reads the key string from the file.

`-c`, `--cipher` *NAME*
  The cipher to decrypt with. See `--list-ciphers` for a list of supported
  ciphers. Default to `aes-256-cbc` if not given.

`-P`, `--password` *PASSWORD*
  The password to decrypt with.

`-H`, `--hash` `md5`\|`sha1`\|`sha256`\|`sha512`
  The hash algorithm to use for the password. Default to `sha256` if not given.

`--iv` *STRING*
  Sets the Initial Vector (IV) value of the cipher.

`--padding` *NUM*
  Sets the padding size, in bytes, of the decryption cipher.

`-b`, `--block-size` *NUM*
  The size, in bytes, to read data in. Default to `16384` if not given.

`--list-ciphers`
  List the supported ciphers and exits.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-encrypt(1)
