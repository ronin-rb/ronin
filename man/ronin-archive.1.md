# ronin-archive 1 "2024-01-18" Ronin "User Manuals"

## NAME

ronin-archive - Archive the files.

## SYNOPSIS

`ronin archive` [*options*] [`-t` \| `--tar`] [`-z` \| `--zip`]  {`-o`,`--output` *s/FILENAME/PATH/* } [*FILE* ...]

## DESCRIPTION

Archive the files.

## ARGUMENTS

*FILE*
: A file to add to the output archive.

*PATH*
: A path to the output file.

## OPTIONS

`-f`, `--format` `tar`\|`zip`
: Archive format.

`-o`, `--output`
: Name of the output file.

## EXAMPLES

Archive files using tar format:

    $ ronin archive -f tar arch1.txt arch2.txt

Archive files using zip format:

    $ ronin archive -f zip arch1.txt arch2.txt

Archive files to the specified file:

    $ ronin archive -o archived.zip arch1.txt arch2.txt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>
