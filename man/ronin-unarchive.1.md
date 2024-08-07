# ronin-unarchive 1 "2024-01-18" Ronin "User Manuals"

## NAME

ronin-unarchive - Unarchive the file(s).

## SYNOPSIS

`ronin unarchive` [*options*] *FILE* ...

## DESCRIPTION

Unarchive one or more `.tar` or `.zip` files.

## ARGUMENTS

*FILE*
: A file to unarchive.

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

## SEE ALSO

[ronin-archive](ronin-archive.1.md)
