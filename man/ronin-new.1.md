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

*dns-proxy*
  Generates a new `ronin-dns-proxy` script.
  See https://github.com/ronin-rb/ronin-dns-proxy#readme

*exploit*
  Generates a new `ronin-exploits` script.
  See https://github.com/ronin-rb/ronin-exploits#readme

*project*
  Generates a new project directory.

*script*
  Generates a new standalone Ruby script.

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
