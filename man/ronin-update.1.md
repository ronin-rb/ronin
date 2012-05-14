# ronin-update 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin update` [*options*] [*REPO*]

## DESCRIPTION

Updates Ronin Repositories.

## ARGUMENTS

*REPO*
  The name of the Repository to update.

## OPTIONS

`-v`, `--[no-]verbose`
  Enable verbose output.

`-q`, `--[no-]quiet`
  Disable verbose output.

`--[no-]silent`
  Silence all output.

`--[no-]color`
  Enables color output.

## FILES

*~/.ronin/*
  Ronin configuration directory.

*~/.ronin/repos*
  Installation directory for Ronin Repositories.

*~/.ronin/database.log*
  Database log.

*~/.ronin/database.sqlite3*
  The default sqlite3 Database file.

*~/.ronin/database.yml*
  Optional Database configuration.

## ENVIRONMENT

HOME
  Specifies the home directory of the user. Ronin will search for the `.ronin`
  configuration directory within the home directory.

DEBUG
  Enables verbose debugging output.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-install(1) ronin-repos(1) ronin-uninstall(1)