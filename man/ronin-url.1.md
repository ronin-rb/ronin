# ronin-url 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-url - Parses URLs

## SYNOPSIS

`ronin url` [*options*] [*URL* ...]

## DESCRIPTION

Processes URL(s) and prints individual components of the URL(s).

## ARGUMENTS

*URL*
: A URL argument to process.

## OPTIONS

`-f`, `--file` *FILE*
: The optional file to read values from.

`-u`, `--user`
: Print the URL's user name component.

`--password`
: Print the URL's password component.

`--user-password`
: Print the URL's user name and password components.

`-H`, `--host`
: Print the URL's host name component.

`--port`
: Print the URL's port component.

`--host-port`
: Print the URL's `host:port` component.

`-P`, `--path`
: Print the URL's path component.

`--path-query`
: Print the URL's path and query string components.

`-Q`, `--query`
: Print the URL's query string component.

`-q`, `--query-param` *NAME*
: Print the query param from the URL's query string.

`-F`, `--fragment`
: Print the URL's fragment component.

`-S`, `--status`
: Print the HTTP status of each URL.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

