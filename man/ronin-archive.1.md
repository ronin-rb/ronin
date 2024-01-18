# ronin-archive 1 "2024-01-18" Ronin "User Manuals"

## NAME

ronin-archive - Archive the files.

## SYNOPSIS

`ronin archive` [*options*] [`-t` \| `--tar`] [`-z` \| `--zip`]  {`-o`,`--output` *FILENAME* } [*FILE* ...]

## DESCRIPTION

Archive the files.

## ARGUMENTS

[*FILE* ...]
: Files to archive.

## OPTIONS

`-t`, `--tar`
: Archive the data using tar.

`-z`, `--zip`
: Archive the data using zip.

`-o`, `--output`
: Name of the output file.

`-f`, `--file` *FILE*
: Optional file to read target values from.

## EXAMPLES

Archive the file using tar:

    $ ronin archive -t foo.txt

Archive the file using zip:

    $ ronin archive -z foo.txt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>
