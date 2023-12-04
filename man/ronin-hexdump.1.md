# ronin-hexdump 1 "2023-02-01" Ronin "User Manuals"

## SYNOPSIS

`ronin hexdump` [*options*] [*FILE* ...]

## DESCRIPTION

Hexdumps data in a variety of encodings and formats.

## ARGUMENTS

*FILE*
: The optional path to the file(s) to hexdump.

## OPTIONS

`-t`, `--type` *TYPE*
: The binary data type to decode the data as. Must be one of the following:

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
: Start reading data at the given offset within the file or data stream.

`-L`, `--length` *LEN*
: Only read at most *LEN* bytes of data.

`-Z`, `--zero-pad`
: Enables zero-padding the input data so that it aligns with the data type
  specified by `-t`,`--type`.

`-c`, `--columns` *WIDTH*
: The number of bytes to hexdump per line.

`-g`, `--group-columns *WIDTH*
: Groups the columns of hexdumped numbers together into groupings of *WIDTH*.

`-G`, `--group-chars` *WIDTH*|`type`
: Group the characters into columns of groupings of *WIDTH*, separated by the
  `|` character. If `type` is given, the size of the `-t`,`--type` type in bytes
  will be used for the character grouping width.

`-r`, `--[no-]repeating`
: Allows consecutive repeating lines in hexdump output. By default consecutive
  repeating lines of data are omitted by a single `*` line.

`-b`, `--base` `2`|`8`|`10`|`16`
: The numeric base to print hexdumped numbers in.

`-B`, `--index-base` `2`|`8`|`10`|`16`
: The numeric base to print the index addresses in.

`-I`, `--index-offset` *INT*
: The starting value for the index addresses.

`-C`, `--[no-]chars-column`
: Enables or disables the display of the characters column.

`-E`, `--encoding` `ascii`|`utf8`
: The character encoding to display the characters in. Default to `ascii`.

`--style-index` *STYLE*
: Applies ANSI styling to the index column.
  See the *ANSI STYLES* section for all possible style names.

`--style-numeric` *STYLE*
: Applies ANSI styling to the numeric column.
  See the *ANSI STYLES* section for all possible style names.

`--style-chars` *STYLE*
: Applies ANSI styling to the characters column.
  See the *ANSI STYLES* section for all possible style names.

`--highlight-index` *PATTERN*:*STYLE*
: Applies ANSI highlighting to the index column.
  *PATTERN* may be either a literal *STRING* value or a /*REGEXP*/ value.
  See the *ANSI STYLES* section for all possible style names.

`--highlight-numeric` *PATTERN*:*STYLE*
: Applies ANSI highlighting to the numeric column
  *PATTERN* may be either a literal *STRING* value or a /*REGEXP*/ value.
  See the *ANSI STYLES* section for all possible style names.

`--highlight-chars` *PATTERN*:*STYLE*
: Applies ANSI highlighting to the characters column
  *PATTERN* may be either a literal *STRING* value or a /*REGEXP*/ value.
  See the *ANSI STYLES* section for all possible style names.

`-h`, `--help`
: Prints help information.

## ANSI STYLES

An ANSI style string is comma-separated list of one or more ANSI style names
(ex: `gray,bold`).

Font styles:

* `bold`
* `faint`
* `italic`
* `underline`
* `invert`
* `strike`

Foreground colors:

* `black`
* `red`
* `green`
* `yellow`
* `blue`
* `magenta`
* `cyan`
* `white`

Background colors:

* `on_black`
* `on_red`
* `on_green`
* `on_yellow`
* `on_blue`
* `on_magenta`
* `on_cyan`
* `on_white`

## EXAMPLES

Hexdump a file:

    $ ronin hexdump /bin/ls
    00000000  7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00  |.ELF............|
    00000010  03 00 3e 00 01 00 00 00 d0 6b 00 00 00 00 00 00  |..>......k......|
    00000020  40 00 00 00 00 00 00 00 18 23 02 00 00 00 00 00  |@........#......|
    00000030  00 00 00 00 40 00 38 00 0d 00 40 00 20 00 1f 00  |....@.8...@. ...|
    00000040  06 00 00 00 04 00 00 00 40 00 00 00 00 00 00 00  |........@.......|
    00000050  40 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00  |@.......@.......|
    ...

Hexdump a UTF-8 data:

    $ ronin hexdump --encoding utf8 file.txt
    00000000  e8 80 80 e8 80 80 e8 80 80 e8 80 80 e8 80 80 e8  |耀耀耀耀耀.|
    00000010  80 80 e8 80 80 e8 80 80                          |..耀耀|
    00000018

Control the number of columns:

    $ ronin hexdump --columns 10 a.txt
    00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    ...

Show repeating data instead of omitting them with a `*`:

    $ ronin hexdump --repeating a.txt
    00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    0000000a  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    00000014  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|

Grouping columns together:

    $ ronin hexdump --group-columns 4 --columns 16 abcd.txt
    00000000  41 42 43 44  41 42 43 44  41 42 43 44  41 42 43 44  |ABCDABCDABCDABCD|
    ...

Grouping the characters together:

    $ ronin hexdump --group-chars 4 abcd.txt
    00000000  41 42 43 44 41 42 43 44 41 42 43 44 41 42 43 44  |ABCD|ABCD|ABCD|ABCD|
    ...

Disabling the characters column:

    $ ronin hexdump --no-chars-column a.txt
    00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
    ...

Print the numbers as decimals (base 10):

    $ ronin hexdump --base 10 hello.txt
    00000000  104 101 108 108 111   0                                          |hello.|

Print the numbers as octals (base 8):

    $ ronin hexdump --base 8 hello.txt
    00000000  0150 0145 0154 0154 0157 0000                                                    |hello.|

Print the numbers as binary (base 2):

    $ ronin hexdump --base 2 hello.txt
    00000000  01101000 01100101 01101100 01101100 01101111 00000000                                                                                            |hello.|

Decode `uint32` values:

    $ ronin hexdump --type uint32 abcd.txt
    00000000  44434241 44434241 44434241 44434241  |ABCDABCDABCDABCD|
    ...

Decode `uint32` (little-endian) values:

    $ ronin hexdump --type uint32_le abcd.txt
    00000000  44434241 44434241 44434241 44434241  |ABCDABCDABCDABCD|
    ...

Decode `uint32` (big-endian) values:

    $ ronin hexdump --type uint32_be abcd.txt
    00000000  41424344 41424344 41424344 41424344  |ABCDABCDABCDABCD|
    ...

Decode `int32` values:

    $ ronin hexdump --type int32 --base 10 data.bin
    00000000       65535         -1                          |........|
    00000008

Decode characters:

    $ ronin hexdump --type char hello.txt
    00000000    h   e   l   l   o  \0                                          |hello.|
    00000006

Decode `float` values:

    $ ronin hexdump --type float64_le floats.bin
    00000000          0.000000e+00         1.000000e+00  |...............?|
    00000010         -1.000000e+00                  NaN  |................|
    ...

Skipping to an offset:

    $ ronin hexdump --offset 7 data.bin

Zero-pad the data:

    $ ronin hexdump --type uint32_be --zero-pad abcd.txt
    00000000  41424344 41424344 41424344 41424344  |ABCDABCDABCDABCD|
    00000010  41420000                             |AB..|
    00000014

ANSI coloring:

    $ ronin hexdump --style-index white \
                    --style-numeric green \
                    --style-chars cyan \
                    data.bin

ANSI highlighting:

    $ ronin hexdump --highlight-index /00$/:white,bold \
                    --highlight-numeric /^[8-f][0-9a-f]$/:faint \
                    --highlight-numeric /f/:cyan \
                    --highlight-numeric 00:black,on_red \
                    --highlight-chars /[^\.]+/:green data.bin

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-unhexdump](ronin-unhexdump.1.md)
