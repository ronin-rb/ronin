# ronin-ip 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin ip` [*options*] [*IP* ...]

## DESCRIPTION

Queries or processes IP addresses.

## ARGUMENTS

*IP*
  An IP address argument to process.

## OPTIONS

`-f`, `--file` *FILE*
  The optional file to read values from.

`-P`, `--public`
  Gets the public IP address.

`-L`, `--local`
  Gets the local IP address.

`-r`, `--reverse`
  Prints the IP address in reverse name format.

`-X`, `--hex`
  Converts the IP address to hexadecimal format.

`-D`, `--decimal`
  Converts the IP address to decimal format.

`-O`, `--octal`
  Converts the IP address to octal format.

`-B`, `--binary`
  Converts the IP address to binary format.

`-C`, `--cidr` *NETMASK*
  Converts the IP address into a CIDR range.

`-H`, `--host`
  Converts the IP address to a host name.

`-p`, `--port` *PORT*
  Appends the port number to each IP.

`-U`, `--uri`
  Converts the IP address into a URI.

`--uri-scheme` *SCHEME*
  The scheme for the URI. Defaults to `http` if not given.

`--uri-port` *PORT*
  The port for the URI.

`--uri-path` /*PATH*
  The absolute path for the URI. Defaults to `/` if not given.

`--uri-query` *STRING*
  The query string for the URI.

`--http`
  Converts the IP address into a http:// URI.

`--https`
  Converts the IP address into a https:// URI.

`-h`, `--help`
  Print help information.

## EXAMPLES

Gets the machine's public IP address:

        $ ronin ip --public

Gets the machine's local network IP address:

        $ ronin ip --local

Converts the IP address(es) into unsigned integers:

        $ ronin ip --uint 1.2.3.4
        16909060

Converts the IP address(es) into CIDR ranges:

        $ ronin ip --cidr 20 1.2.3.4
        1.2.0.0/20

Converts the IP address(es) into host names:

        $ ronin ip --host 192.30.255.113
        lb-192-30-255-113-sea.github.com

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

