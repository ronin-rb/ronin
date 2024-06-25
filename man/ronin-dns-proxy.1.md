# ronin-dns-proxy 1 "2024-01-01" Ronin "User Manuals"

## NAME

ronin-dns-proxy - Starts a DNS proxy

## SYNOPSIS

`ronin dns-proxy` [*options*] [*HOST*] *PORT*

## DESCRIPTION

Starts a DNS proxy that can intercept DNS queries and forward other queries to
upstream DNS nameservers.

## ARGUMENTS

*HOST*
: The optional IP address to listen on.

*PORT*
: The port number to listen on.

## OPTIONS

`-n`, `--nameserver` *IP*
: A nameserver IP address to foreward DNS queries to.

`-r`, `--rule` *RECORD_TYPE*`:`*NAME*`:`*RESULT*\|*RECORD_TYPE*`:/`*REGEXP*`/:`*RESULT*
: Adds a rule to the DNS proxy. Each rule consists of a *RECORD_TYPE*, *NAME*,
  and a *RESULT*.

  The *RECORD_TYPE* is a DNS record type:

  * `A`
  * `AAAA`
  * `ANY`
  * `CNAME`
  * `HINFO`
  * `LOC`
  * `MINFO`
  * `MX`
  * `NS`
  * `PTR`
  * `SOA`
  * `SRV`
  * `TXT`
  * `WKS`

  The *NAME* is the host name of the record.
  If the *NAME* starts with a `/` and ends with a `/`, then it will be treated
  as a Regex.

  The *RESULT* is either the result value or an DNS error code:

  * `NoError`
  * `FormErr`
  * `ServFail`
  * `NXDomain`
  * `NotImp`
  * `Refused`
  * `NotAuth`

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-dns](ronin-dns.1.md)
