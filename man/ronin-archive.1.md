# ronin-archive 1 "2024-01-18" Ronin "User Manuals"

## NAME

ronin-archive - Archive the files.

## SYNOPSIS

`ronin archive` [*options*] {`-o`,`--output` *PATH* } *FILE* ...

## DESCRIPTION

Archive the files.

## ARGUMENTS

*FILE*
: A file to add to the output archive.

## OPTIONS

`-f`, `--format` `tar`\|`zip`
: Archive format.

`-o`, `--output` *PATH*
: Path to the output file.

## EXAMPLES

Archive files using tar format:

    $ ronin archive -f tar -o archived.tar arch1.txt arch2.txt

Archive files using zip format:

    $ ronin archive -f zip -o archived.zip arch1.txt arch2.txt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>
