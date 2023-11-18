# ronin-new 1 "2023-02-01" Ronin "User Manuals"

## SYNOPSIS

`ronin new` [*options*] [*COMMAND*]

## DESCRIPTION

Creates a new project or script.

## ARGUMENTS

*COMMAND*
	The optional command to get detailed new information on.

## OPTIONS

`-h`, `--help`
  Print help information

## COMMANDS

*dns-listener*
  Generates a new `ronin-listener-dns` script.
  See https://github.com/ronin-rb/ronin-listener-dns#readme

*dns-proxy*
  Generates a new `ronin-dns-proxy` script.
  See https://github.com/ronin-rb/ronin-dns-proxy#readme

*http-listener*
  Generates a new `ronin-listener-http` script.
  See https://github.com/ronin-rb/ronin-listener-http#readme

*exploit*
  Generates a new `ronin-exploits` script.
  See https://github.com/ronin-rb/ronin-exploits#readme

*payload*
  Generates a new `ronin-payloads` script.
  See https://github.com/ronin-rb/ronin-payloads#readme

*project*
  Generates a new project directory.

*script*
  Generates a new standalone Ruby script.

*nokogiri*
  Generates a new Nokogiri Ruby script for parsing HTML/XML.
  See https://nokogiri.org/

*web-server*
  Generates a new `ronin-web-server` Ruby script.
  See https://github.com/ronin-rb/ronin-web-server#readme

*web-app*
  Generates a new `ronin-web-server` based web app.
  See https://github.com/ronin-rb/ronin-web-server#readme

*web-spider*
  Generates a new `ronin-web-spider` Ruby script.
  See https://github.com/ronin-rb/ronin-web-spider#readme

*help*
  Lists available `ronin new` commands.

## EXAMPLES

Generate a new Ruby script:

        ronin new script file.rb

Generate a new Ruby project:

        ronin new project path/to/dir

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-new-script(1) ronin-new-project(1)
