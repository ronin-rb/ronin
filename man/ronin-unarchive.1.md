# ronin-unarchive 1 "2024-01-18" Ronin "User Manuals"

## NAME

ronin-unarchive - Unarchive the files.

## SYNOPSIS

`ronin unarchive` [*options*] *FILE* ...

## DESCRIPTION

Unarchive the files.

## ARGUMENTS

*FILE*
: Files to unarchive.

## OPTIONS

`-f`, `--format` `tar`\|`zip`
: Explicit archive format

## EXAMPLES

Archive the file using tar:

    $ ronin unarchive foo.tar

Archive the file using explicit format:

    $ ronin unarchive -f zip foo.jar

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>
