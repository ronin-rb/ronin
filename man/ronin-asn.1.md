# ronin-asn 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin asn` [*options*] [`-v` \| `--enum-ips`] {`-n`,`--number` *NUMBER* \| `-c`,`--country` *COUNTRY* \| `-N`,`--name` *NAME* \| `-I`,`--ip` *IP*}

## DESCRIPTION

Queries ASN information for the given *IP* or searches for the ASN records for
the given *NUMBER*, *NAME*, or *COUNTRY* code.

## OPTIONS

`-v`, `--verbose`
  Prints multi-line human readable output.

`-U`, `--ur`l *URI*
  Overrides the default ASN list URL. Defaults to
  `https://iptoasn.com/data/ip2asn-combined.tsv.gz`.

`-f`, `--file` *FILE*
  Overrides the default ASN list file. Defaults to
  `~/.cache/ronin/ronin-support/ip2asn-combined.tsv.gz`.

`-u`, `--update`
  Updates the ASN list file.

`-n`, `--number` *NUM*\|AS*NUM*
  Searches for all ASN records with the AS number.

`-C`, `--country-code` *XX*|`None`|`Uknown`
  Searches for all ASN records with the country code.

`-N`, `--name` *NAME*
  Searches for all ASN records with the matching name.

`-I`, `--ip` *IP*
  Queries the ASN record for the IP.

`-4`, `--ipv4`
  Filters ASN records for only IPv4 ranges.

`-6`, `--ipv6`
  Filter ASN records for only IPv6 ranges.

`-E`, `--enum-ips`
  Enumerate over the IPs within the ASN ranges.

`-h`, `--help`
  Print help information

## EXAMPLES

Print verbose output for all ASN records for `AS15133`:

        ronin asn -v -n 15133

Print verbose output for the ASN record for the IP address `93.184.216.34`:

        ronin asn -v -I 93.184.216.34

Prints all ASN records for the given country code:

        ronin asn -C US

Prints all ASN records for the given ISP:

        ronin asn -N EDGECAST

Enumerate over the IP addresses in the IP range for `AS15133`:

        ronin asn --enum-ips -n 15133

Enumerate over all IP addresses for all ASN records belonging to the given ISP:

        ronin asn --enum-ips -N EDGECAST

## FILES

`~/.cache/ronin/ronin-support/ip2asn-combined.tsv.gz`
  The location of the downloaded ASN list.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

