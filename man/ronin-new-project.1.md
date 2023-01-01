# ronin-new-project 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin new project` [*options*] *PATH*

## DESCRIPTION

Creates a new Ruby project directory.

## ARGUMENTS

*PATH*
	The path to the new project directory.

## OPTIONS

`--git`
  Initializes a git repo.

`--ruby-version` *VERSION*
  The desired ruby version for the project. Defaults to the current `ruby`
  version if not specified.

`--rakefile`
  Creates a `Rakefile`.

`--dockerfile`
  Adds a `Dockerfile` to the new project.

`-h`, `--help`
  Print help information

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-new-script(1)
