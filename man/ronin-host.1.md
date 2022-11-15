# ronin-host 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin host` [*options*] [*HOST* ...]

## DESCRIPTION

Processes hostname(s) and performs DNS queries.

## ARGUMENTS

*HOST*
  A host name argument to query.

## OPTIONS

`-f`, `--file` *FILE*
  Optional file to read values from.

`-d`, `--domain`
  Converts the hostname to a domain.

`-s`, `--suffix`
  Converts the hostname to it's suffix.

`-S`, `--change-suffix` *SUFFIX*
  Changes the suffix of each hostname.

`--enum-suffixes`
  Enumerates over every public suffix.

`-N`, `--nameserver` *HOST*|*IP*
  Send DNS queries to the nameserver.

`-I`, `--ips`
  Converts the hostname to it's IP addresses.

`-A`, `--has-addresses`
  Filters hostnames that have addresses.

`-T`, `--has-records`  `A`\|`AAAA`\|`ANY`\|`CNAME`\|`HINFO`\|`LOC`\|`MINFO`\|`MX`\|`NS`\|`PTR`\|`SOA`\|`SRV`\|`TXT`\|`WKS`
  Filters hostnames that have a certain DNS record type.

`-t`, `--query` `A`\|`AAAA`\|`ANY`\|`CNAME`\|`HINFO`\|`LOC`\|`MINFO`\|`MX`\|`NS`\|`PTR`\|`SOA`\|`SRV`\|`TXT`\|`WKS`
  Queries a specific type of DNS record.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

