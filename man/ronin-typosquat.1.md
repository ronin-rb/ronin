# ronin-typosquat 1 "2023-02-01" Ronin "User Manuals"

## NAME

ronin-typosquat - Finds typo squatted domains

## SYNOPSIS

`ronin typosquat` [*options*] [DOMAIN ...]

## DESCRIPTION

Finds typo squatted domains.

## ARGUMENTS

*DOMAIN*
: A domain to check for typo squats.

## OPTIONS

`-f`, `--file` *FILE*
: Optional file to read domains from.

`--omit-chars`
: Toggles whether to omit repeated characters.

`--repeat-chars`
: Toggles whether to repeat single characters.

`--swap-chars`
: Toggles whether to swap certain common character pairs.

`--change-suffix`
: Toggles whether to change the suffix of words.

`-A`, `--has-addresses`
: Print typo squat domains with addresses.

`-r`, `--registered`
: Print typo squat domains that are already registered.

`-u`, `--unregistered`
: Print typo squat domains that can be registered.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-typo](ronin-typo.1.md)