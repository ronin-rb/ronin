# ronin-new-project 1 "2023-02-01" Ronin "User Manuals"

## SYNOPSIS

`ronin new project` [*options*] *PATH*

## DESCRIPTION

Creates a new Ruby project directory.

## ARGUMENTS

*PATH*
: The path to the new project directory.

## OPTIONS

`--git`
: Initializes a git repo.

`--ruby-version` *VERSION*
: The desired ruby version for the project. Defaults to the current `ruby`
  version if not specified.

`--rakefile`
: Creates a `Rakefile`.

`--dockerfile`
: Adds a `Dockerfile` to the new project.

`-h`, `--help`
: Print help information

## EXAMPLES

Generate a new Ruby project:

    ronin new project path/to/dir

Set the desired ruby version for the project:

    ronin new project --ruby-version 3.2.0 path/to/dir

Add a `Rakefile` to the project for defining automated tasks:

    ronin new project --rakefile path/to/dir

Add a `Dockerfile` to the project:

    ronin new project --dockerfile path/to/dir

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-new-script](ronin-new-script.1.md)