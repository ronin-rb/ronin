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

`--subdomain` *SUBNAME*
  Converts the hostname to a sub-domain.

`-d`, `--domain`
  Converts the hostname to a domain.

`-T`, `--tld`
  Converts the hostname to it's TLD.

`-s`, `--suffix`
  Converts the hostname to it's suffix.

`-S`, `--change-suffix` *SUFFIX*
  Changes the suffix of each hostname.

`--enum-tlds`
  Enumerates over every TLD.

`--enum-suffixes`[`=``icann`|`private`]
  Enumerates over every public suffix. An optional value of `icann` or `private`
  can be given to only enumerate ICANN suffixes or private suffixes.

`-N`, `--nameserver` *HOST*|*IP*
  Send DNS queries to the nameserver.

`-I`, `--ips`
  Converts the hostname to it's IP addresses.

`-r`, `--registered`
  Filters hostnames that are registered.

`-u`, `--unreigstered`
  Filters hostnames that are unregistered.

`-A`, `--has-addresses`
  Filters hostnames that have addresses.

`-H`, `--has-records` `A`\|`AAAA`\|`ANY`\|`CNAME`\|`HINFO`\|`LOC`\|`MINFO`\|`MX`\|`NS`\|`PTR`\|`SOA`\|`SRV`\|`TXT`\|`WKS`
  Filters hostnames that have a certain DNS record type.

`-t`, `--query` `A`\|`AAAA`\|`ANY`\|`CNAME`\|`HINFO`\|`LOC`\|`MINFO`\|`MX`\|`NS`\|`PTR`\|`SOA`\|`SRV`\|`TXT`\|`WKS`
  Queries a specific type of DNS record.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

