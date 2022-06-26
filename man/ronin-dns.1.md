# ronin-dns 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin dns` [*options*] *HOST*

## DESCRIPTION

Queries DNS records for the given host name.

## ARGUMENTS

*HOST*
  The host name to query.

## OPTIONS

`-N`, `--nameserver` *HOST*|*IP*
  Send DNS queries to the nameserver.

`-t`, `--type` `A|AAAA|ANY|CNAME|HINFO|LOC|MINFO|MX|NS|PTR|SOA|SRV|TXT|WKS`
  The type of record to query.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

