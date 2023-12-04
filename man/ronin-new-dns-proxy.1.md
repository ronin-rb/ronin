# ronin-new-dns-proxy.1 "2023-02-01" Ronin "User Manuals"

## SYNOPSIS

`ronin new dns-proxy` [*options*] *PATH*

## DESCRIPTION

Creates a new `ronin-dns-proxy` script.

See https://github.com/ronin-rb/ronin-dns-proxy#readme

## ARGUMENTS

*PATH*
: The path to the new script file.

## OPTIONS

`-H`, `--host` *IP*
: The IP to listen on. Defaults to `127.0.0.1` if not specified.

`-p`, `--port` *PORT*
: The port number to listen on. Defaults to `2345` if not specified.

`-h`, `--help`
: Print help information

## EXAMPLES

Generate a new `ronin-dns-proxy` script:

    $ ronin new dns-proxy proxy.rb

See https://github.com/ronin-rb/ronin-dns-proxy#examples for more
`ronin-dns-proxy` examples.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-new-script](ronin-new-script.1.md)
