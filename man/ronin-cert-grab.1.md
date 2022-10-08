# ronin-cert-grab 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin cert-grab` [*options*] {*HOST*:*PORT* \| *URL*} ...

## DESCRIPTION

Downloads SSL/TLS certificates for a SSL/TLS TCP or `https://` URL.

## ARGUMENTS

*HOST*:*PORT*
  A remote TCP service to retrieve the SSL/TLS certificate from and print.

*URL*
  An URL to retrieve the SSL/TLS certificate from and print.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to read target values from.

`-h`, `--help`
  Print help information.

## EXAMPLES

Downloads the SSL/TLS certificate for a SSL/TLS service:

    ronin cert-grab github.com:443

Downloads the SSL/TLS certificate running on the IP and port:

    ronin cert-grab 93.184.216.34:443

Downloads the SSL/TLS certificate used by the URL:

    ronin cert-grab https://github.com/

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-cert-dump(1) ronin-cert-gen(1)
