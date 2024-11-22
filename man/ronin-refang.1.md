# ronin-refang 1 "2025-01-01" Ronin "User Manuals"

## NAME

ronin-refang - Refangs a defanged URLs, hostnames, or IP addresses

## SYNOPSIS

`ronin refang` [*options*] [{*URL* \| *HOST* \| *IP*} ...]

## DESCRIPTION

Re-fangs previously defanged URL(s), hostname(s), or IP address(es) and prints
the original URL, hostname, or IP address value.

## ARGUMENTS

*URL*
: A defanged URL argument to refang
  (ex: `hxxps://www[.]evil[.]com/foo/bar/baz`).

*HOST*
: A defanged hostname argument to refang (ex: `www[.]example[.]com`).

*IP*
: A defanged IP address argument to refang (ex: `192[.]168[.]1[.]1`).

## OPTIONS

`-f`, `--file` *FILE*
: The optional file to read values from.

`-h`, `--help`
: Print help information.

## EXAMPLES

Re-fangs a defanged URL:

    ronin refang hxxps://www[.]evil[.]com/foo/bar/baz

Re-fangs a defanged hostname:

    ronin refang www[.]example[.]com

Re-fangs a defanged IP address:

    ronin refang 192[.]168[.]1[.]1

Re-fangs a file of URLs, hostnames, or IP addresses:

    ronin refang --file urls.txt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-defang](ronin-defang.1.md)
