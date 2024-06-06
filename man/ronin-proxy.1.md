# ronin-proxy 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-proxy - Starts a TCP/UDP/SSL/TLS intercept proxy server

## SYNOPSIS

`ronin proxy` [*options*] [*PROXY_HOST*:]*PROXY_PORT* *UPSTREAM_HOST*:*UPSTREAM_PORT*

## DESCRIPTION

Starts a TCP/UDP/SSL/TLS proxy server.

## ARGUMENTS

*PROXY_HOST*
: The local host to listen on.

*PROXY_PORT*
: The local port to bind to.

*UPSTREAM_HOST*
: The upstream host to proxy data to.

*UPSTREAM_PORT*
: The upstream port to proxy data to.

## OPTIONS

`-t`, `--tcp`
: Enables or disables TCP mode.

`-S`, `--ssl`
: Enables or disables SSL mode.

`-T`, `--tls`
: Enables or disables TLS mode.

`-u`, `--udp`
: Enables or disables UDP mode.

`-x`, `--[no-]hexdump`
: Enables or disables hexdump mode.

`-r`, `--rewrite` */REGEXP/:STRING*
: Replace REGEXP with STRING in every message.

`--rewrite-client` */REGEXP/:STRING*
: Replace REGEXP with STRING in every client message.

`--rewrite-server` */REGEXP/:STRING*
: Replace REGEXP with STRING in every server message.

`-i`, `--ignore` */REGEXP/*
: Ignore messages matching the REGEXP.

`--ignore-client` */REGEXP/*
: Ignore messages from the client matching the REGEXP.

`--ignore-server` */REGEXP/*
: Ignore messages from the server matching the REGEXP.

`-C`, `--close` */REGEXP/*
: Closes the connection if the client or server sends a message matching
  the REGEXP.

`--close-client` */REGEXP/*
: Closes the connection if the client sends a message matching the REGEXP.

`--close-server` */REGEXP/*
: Closes the connection if the server sends a message matching the REGEXP.

`-R`, `--reset` */REGEXP/*
: Reset the connection if the client or server sends a message matching
  the REGEXP.

`--reset-client` */REGEXP/*
: Reset the connection if the client sends a message matching the REGEXP.

`--reset-server` */REGEXP/*
: Reset the connection if the server sends a message matching the REGEXP.

## EXAMPLES

Starts a TCP proxy listening on `localhost` port 8080 that forwards all data
to `google.com` port 80:

    $ ronin proxy 8080 google.com:80

Starts a UDP proxy listening on `0.8.0.0` port 53 that forwards all data to
`8.8.8.8` port 53:

    $ sudo ronin proxy --udp --hexdump 0.0.0.0:53 8.8.8.8:53

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

