# ronin-typosquat 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin typosquat` [*options*] DOMAIN

## DESCRIPTION

Finds typo squatted domains.

## ARGUMENTS

*DOMAIN*
  The domain to typo squat.

## OPTIONS

`--omit-chars`
  Toggles whether to omit repeated characters.

`--repeat-chars`
  Toggles whether to repeat single characters.

`--swap-chars`
  Toggles whether to swap certain common character pairs.

`--change-suffix`
  Toggles whether to change the suffix of words.

`-A`, `--has-addresses`
  Print typo squat domains with addresses.

`-r`, `--registered`
  Print typo squat domains that are already registered.

`-u`, `--unregistered`
  Print typo squat domains that can be registered.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-typo(1)
