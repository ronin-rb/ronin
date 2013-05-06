# ronin-exec 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin exec` *SCRIPT* [*ARGS* ...]

## DESCRIPTION

Runs a script from a Ronin Repository.

## ARGUMENTS

*SCRIPT*
	The name of the script to search for within the `bin/` directories within the
	Repositories.

*ARGS*
	Additional arguments to pass to the SCRIPT.

## FILES

*~/.ronin/*
	Ronin configuration directory.

*~/.ronin/config.rb*
	Configuration file that is loaded before the Ronin Console starts.

*~/.ronin/console.log*
	History log for the Ronin Console.

*~/.ronin/database.log*
	Database log.

*~/.ronin/database.sqlite3*
	The default sqlite3 Database file.

*~/.ronin/database.yml*
	Optional Database configuration.

## ENVIRONMENT

HOME
	Specifies the home directory of the user. Ronin will search for the
	*~/.ronin* configuration directory within the home directory.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

