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
: The archive format to use. If not specified the archive format will be
  inferred from the output file's extension.

`-o`, `--output` *PATH*
: Path to the output file.

## EXAMPLES

Archive files using tar format:

    $ ronin archive -o archived.tar arch1.txt arch2.txt

Archive files using zip format:

    $ ronin archive -o archived.zip arch1.txt arch2.txt

Explicitly specify the archive format:

    $ ronin archive -f zip archive.jar file1.txt file2.txt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>
