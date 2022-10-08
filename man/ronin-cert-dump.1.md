# ronin-cert-dump 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin cert-dump` [*options*] {*HOST*:*PORT* \| *URL* \| *FILE*} ...

## DESCRIPTION

Prints SSL/TLS certificate information for one or more SSL/TLS services,
`https://` URLs, or certificate files.

## ARGUMENTS

*HOST*:*PORT*
  A remote TCP service to retrieve the SSL/TLS certificate from and print.

*URL*
  An URL to retrieve the SSL/TLS certificate from and print.

*FILE*
  A SSL/TLS certificate file to print.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to read target values from.

`-C`, `--common-name`
  Only prints the Common Name (CN) for each certificate.

`-A`, `--subject-alt-names`
  Only prints the `subjectAltName`s for each certificate.

`-E`, `--extensions`
  Also prints the extensions for each certificate.

`-h`, `--help`
  Print help information.

## EXAMPLES

Print the certificate information for the cert file:

    ronin cert-dump ssl.crt

Print the certificate information for a SSL/TLS service:

    ronin cert-dump github.com:443

Print the certificate information for a URL:

    ronin cert-dump https://github.com

Only print the Common Nmae (CN) for a SSL/TLS service:

    ronin cert-dump -C 93.184.216.34:443

Only print the `subjectAltName`s for a SSL/TLS service:

    ronin cert-dump -A wired.com:443

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-cert-grab(1) ronin-cert-gen(1)
