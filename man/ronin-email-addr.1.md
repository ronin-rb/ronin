# ronin-email-addr 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-email-addr - Processes email addresses

## SYNOPSIS

`ronin email-addr` [*options*] [*EMAIL_ADDR* ...]

## DESCRIPTION

Processes one or more email addresses.

## OPTIONS

`-f`, `--file` *FILE*
: Optional input file to read the email addresses from.

`-O`, `--obfuscate`
: Obfuscates the given email address(es).

`--enum-obfuscations`
: Enumerate over every possible obfuscation of the given email address(es).

`-D`, `--deobfuscate`
: Deobfuscates the given email address(es).

`-n`, `--name`
: Extracts the Name part of the email address(es).

`-m`, `--mailbox`
: Extracts the mailbox part of the email address(es).

`-d`, `--domain`
: Extracts the domain part of the email address(es).

`-N`, `--normalize`
: Normalizes the given email address(es) by removing the Name, routing,
  and mailbox tag.

`-h`, `--help`
: Print help information

## EXAMPLES

Deobfuscates an email address:

    $ ronin email-addr --deobfuscate "john{DOT}smith{AT}example{DOT}com"'

Extracts the domain name from a list of email addresses:

    $ ronin email-addr --file emails.txt --domain

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

