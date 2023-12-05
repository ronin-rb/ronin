# ronin-bitsquat 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-bitsquat - Finds bit-flips of a domain

## SYNOPSIS

`ronin bitsquat` [*options*] [*DOMAIN* ...]

## DESCRIPTION

Bitflips a domain and checks if it has any DNS records.

## ARGUMENTS

*DOMAIN*
: A domain to bitflip and query.

## OPTIONS

`-f`, `--file` *FILE*
: Optional file to read domains from.

`--has-addresses`
: Print bitsquat domains with addresses.

`--registered`
: Print bitsquat domains that are already registered.

`--unregistered`
: Print bitsquat domains that can be registered.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-bitflip](ronin-bitflip.1.md)