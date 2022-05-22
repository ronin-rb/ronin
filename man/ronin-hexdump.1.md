# ronin-hexdump 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin hexdump` [*options*] [*FILE*]`

## DESCRIPTION

Hexdumps data in a variety of encodings and formats.

## ARGUMENTS

*FILE*
  The optional path to the file to hexdump.

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

`-O`, `--offset` *INDEX*
  Start reading data at the given offset within the file or data stream.

`-L`, `--length` *LEN*
  Only read at most *LEN* bytes of data.

`-Z`, `--zero-pad`
  Enables zero-padding the input data so that it aligns with the data type
  specified by `-t`,`--type`.

`-c`, `--columns` *WIDTH*
  The number of bytes to hexdump per line.

`-g`, `--group-columns *WIDTH*
  Groups the columns of hexdumped numbers together into groupings of *WIDTH*.

`-G`, `--group-chars` *WIDTH*|`type`
  Group the characters into columns of groupings of *WIDTH*, separated by the
  `|` character. If `type` is given, the size of the `-t`,`--type` type in bytes
  will be used for the character grouping width.

`-r`, `--[no-]repeating`
  Allows consecutive repeating lines in hexdump output. By default consecutive 
  repeating lines of data are omitted by a single `*` line.

`-b`, `--base` `2`|`8`|`10`|`16`
  The numeric base to print hexdumped numbers in.

`-B`, `--index-base` `2`|`8`|`10`|`16`
  The numeric base to print the index addresses in.

`-I`, `--index-offset` *INT*
  The starting value for the index addresses.

`-C`, `--[no-]chars-column`
  Enables or disables the display of the characters column.

`-E`, `--encoding` `ascii`|`utf8`
  The character encoding to display the characters in. Default to `ascii`.

`-h`, `--help`
  Prints help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-unhexdump(1)
