# ronin-defang 1 "2025-01-01" Ronin "User Manuals"

## NAME

ronin-defang - Defangs a URLs, hostnames, or IP addresses

## SYNOPSIS

`ronin defang` [*options*] [{*URL* \| *HOST* \| *IP*} ...]

## DESCRIPTION

De-fangs URL(s), hostname(s), or IP address(es).

## ARGUMENTS

*URL*
: A URL argument to defang
  (ex: `https://www.evil.com/foo/bar/baz`).

*HOST*
: A hostname argument to defang (ex: `www.example.com`).

*IP*
: A IP address argument to defang (ex: `192.168.1.1`).

## OPTIONS

`-f`, `--file` *FILE*
: The optional file to read values from.

`-h`, `--help`
: Print help information.

## EXAMPLES

De-fangs a URL:

    ronin defang https://www.evil.com/foo/bar/baz

De-fangs a hostname:

    ronin defang www.example.com

De-fangs a IP address:

    ronin defang 192.168.1.1

De-fangs a file of URLs, hostnames, or IP addresses:

    ronin defang --file urls.txt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-refang](ronin-refang.1.md)
