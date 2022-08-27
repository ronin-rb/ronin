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

`-u`, `--uint`
  Converts the IP address to an unsigned integer.

`-C`, `--cidr` *NETMASK*
  Converts the IP address into a CIDR range.

`-H`, `--host`
  Converts the IP address to a host name.

`-p`, `--port` *PORT*
  Appends the port number to each IP.

`-U`, `--uri` *SCHEME*
  Converts the IP address into a URI with the given *SCHEME*.

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

