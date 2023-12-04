# ronin-dns 1 "2023-02-01" Ronin "User Manuals"

## SYNOPSIS

`ronin dns` [*options*] {*HOST* ... \| `--file` *FILE*}

## DESCRIPTION

Queries DNS records for the given host name.

## ARGUMENTS

*HOST*
: A host name argument to query.

## OPTIONS

`-f`, `--file` *FILE*
: The optional file to read values from.

`-N`, `--nameserver` *HOST*|*IP*
: Send DNS queries to the nameserver.

`-t`, `--type` `A|AAAA|ANY|CNAME|HINFO|LOC|MINFO|MX|NS|PTR|SOA|SRV|TXT|WKS`
: The type of record to query.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

