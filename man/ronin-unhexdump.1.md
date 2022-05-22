# ronin-unhexdump 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin unhexdump` [*options*] [*FILE*]`

## DESCRIPTION

Un-hexdumps a hexdump back into it's original raw data.
Supports a variety of formats, bases, and encodings.

## ARGUMENTS

*FILE*
  The optional path to the file to un-hexdump.

## OPTIONS

`-o`, `--output` *FILE*
  Optional path to the output file.

`-t`, `--type` *TYPE*
  The binary data type to decode the data as. Must be one of the following:

  * `int8`
  * `uint8`
  * `char`
  * `uchar`
  * `byte`
  * `int16`
  * `int16_le`
  * `int16_be`
  * `int16_ne`
  * `uint16`
  * `uint16_le`
  * `uint16_be`
  * `uint16_ne`
  * `short`
  * `short_le`
  * `short_be`
  * `short_ne`
  * `ushort`
  * `ushort_le`
  * `ushort_be`
  * `ushort_ne`
  * `int32`
  * `int32_le`
  * `int32_be`
  * `int32_ne`
  * `uint32`
  * `uint32_le`
  * `uint32_be`
  * `uint32_ne`
  * `int`
  * `long`
  * `long_le`
  * `long_be`
  * `long_ne`
  * `uint`
  * `ulong`
  * `ulong_le`
  * `ulong_be`
  * `ulong_ne`
  * `int64`
  * `int64_le`
  * `int64_be`
  * `int64_ne`
  * `uint64`
  * `uint64_le`
  * `uint64_be`
  * `uint64_ne`
  * `long_long`
  * `long_long_le`
  * `long_long_be`
  * `long_long_ne`
  * `ulong_long`
  * `ulong_long_le`
  * `ulong_long_be`
  * `ulong_long_ne`
  * `float`
  * `float_le`
  * `float_be`
  * `float_ne`
  * `double`
  * `double_le`
  * `double_be`
  * `double_ne`

`-b`, `--base` `2`|`8`|`10`|`16`
  The numeric base to print hexdumped numbers in.

`-A`, `--address-base` `2`|`8`|`10`|`16`
  The numeric base to print the index addresses in.

`--[no-]named-chars`
  Enables parsing of `od`-style named characters (ex: `nul`).

`-h`, `--help`
  Prints help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-hexdump(1), hexdump(1), od(1)
