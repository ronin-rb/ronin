# ronin-pack 1 "2024-01-01" Ronin "User Manuals"

## NAME

ronin-pack - Packs values into binary data.

## SYNOPSIS

`ronin pack` [*options*] {*TYPE*`:`*VALUE* | *TYPE*`[`*NUM*`]`:*VALUE*[`,`*VALUE*...] [...]

## DESCRIPTION

Packs the list of *VALUE*s into binary data based on their C *TYPE* name.

## ARGUMENTS

*TYPE*
: The desired C type to pack the value as. See the **TYPES** section below for a
  complete list of type names.

*VALUE*
: The value to pack.

Note: to specify an array type, put the array length in square brackets after
the *TYPE* and list multiple values as a comma separated list.

    int32[4]:1,2,3,4

    char[3]:a,b,c

## OPTIONS

`-E`, `--endian` `little`\|`big`\|`net`
: Sets the endianness

`-A`, `--arch` `x86`\|`x86_64`\|`ppc`\|`ppc64`\|`mips`\|`mips_le`\|`mips_be`\|`mips64`\|`mips64_le`\|`mips64_be`\|`arm`\|`arm_le`\|`arm_be`\|`arm64`\|`arm64_le`\|`arm64_be`
: Sets the architecture.

`-O`, `--os` `linux`\|`macos`\|`windows`\|`android`\|`apple_ios`\|`bsd`\|`freebsd`\|`openbsd`\|`netbsd`
: Sets the OS.

`-x`, `--hexdump`
: Print a hexdump of the packed data.

  Note: this option will disable `--output` and print a hexdump of the packed
  data instead of writing it out to a file.

`--output` *PATH*
: Optional output file to write to.

`-h`, `--help`
: Prints help information.

## TYPES

```
char
uchar
byte
string
int
int8
int16
int32
int64
short
long
long_long
uint
uint8
uint16
uint32
uint64
ushort
ulong
ulong_long
float
float32
float64
double
pointer
```

### Little Endian

```
int_le
int16_le
int32_le
int64_le
short_le
long_le
long_long_le
uint_le
uint16_le
uint32_le
uint64_le
ushort_le
ulong_le
ulong_long_le
float_le
float32_le
float64_le
double_le
pointer_le
```

### Big Endian

```
int_be
int16_be
int32_be
int64_be
short_be
long_be
long_long_be
uint_be
uint16_be
uint32_be
uint64_be
ushort_be
ulong_be
ulong_long_be
float_be
float32_be
float64_be
double_be
pointer_be
```

### Network Endian

```
int_net
int16_net
int32_net
int64_net
short_net
long_net
long_long_net
uint_net
uint16_net
uint32_net
uint64_net
ushort_net
ulong_net
ulong_long_net
float_net
float32_net
float64_net
double_net
pointer_net
```

### Linux Types

```
__blkcnt64_t
__blkcnt_t
__blksize_t
__caddr_t
__clock_t
__clockid_t
__daddr_t
__dev_t
__fd_mask
__fsblkcnt64_t
__fsblkcnt_t
__fsfilcnt64_t
__fsfilcnt_t
__fsword_t
__gid_t
__id_t
__ino64_t
__ino_t
__int16_t
__int32_t
__int64_t
__int8_t
__intmax_t
__intptr_t
__key_t
__loff_t
__mode_t
__nlink_t
__off64_t
__off_t
__pid_t
__priority_which_t
__quad_t
__rlim64_t
__rlim_t
__rlimit_resource_t
__rusage_who_t
__sig_atomic_t
__socklen_t
__ssize_t
__suseconds_t
__syscall_slong_t
__syscall_ulong_t
__time_t
__timer_t
__u_char
__u_int
__u_long
__u_quad_t
__u_short
__uid_t
__uint16_t
__uint32_t
__uint64_t
__uint8_t
__uintmax_t
__useconds_t
blkcnt_t
blksize_t
clock_t
clockid_t
daddr_t
dev_t
fd_mask
fsblkcnt_t
fsfilcnt_t
gid_t
id_t
in_addr_t
in_port_t
ino_t
int16_t
int32_t
int64_t
int8_t
int_fast16_t
int_fast32_t
int_fast64_t
int_fast8_t
int_least32_t
int_least64_t
int_least8_t
intmax_t
intptr_t
key_t
loff_t
mode_t
nlink_t
off_t
pid_t
pthread_key_t
pthread_once_t
pthread_t
ptrdiff_t
quad_t
register_t
rlim_t
sa_family_t
size_t
socklen_t
ssize_t
suseconds_t
time_t
timer_t
u_char
u_int
u_int16_t
u_int32_t
u_int64_t
u_int8_t
u_long
u_quad_t
u_short
uid_t
uint16_t
uint32_t
uint64_t
uint8_t
uint_fast16_t
uint_fast32_t
uint_fast64_t
uint_fast8_t
uint_least16_t
uint_least32_t
uint_least64_t
uint_least8_t
uintmax_t
uintptr_t
wchar_t
```

### macOS / iOS Types

```
__darwin_blkcnt_t
__darwin_blksize_t
__darwin_clock_t
__darwin_ct_rune_t
__darwin_dev_t
__darwin_fsblkcnt_t
__darwin_fsfilcnt_t
__darwin_gid_t
__darwin_id_t
__darwin_ino64_t
__darwin_ino_t
__darwin_intptr_t
__darwin_mach_port_name_t
__darwin_mach_port_t
__darwin_mode_t
__darwin_natural_t
__darwin_off_t
__darwin_pid_t
__darwin_pthread_key_t
__darwin_ptrdiff_t
__darwin_rune_t
__darwin_sigset_t
__darwin_size_t
__darwin_socklen_t
__darwin_ssize_t
__darwin_suseconds_t
__darwin_time_t
__darwin_uid_t
__darwin_useconds_t
__darwin_uuid_string_t
__darwin_uuid_t
__darwin_wchar_t
__darwin_wint_t
__int16_t
__int32_t
__int64_t
__int8_t
__uint16_t
__uint32_t
__uint64_t
__uint8_t
blkcnt_t
blksize_t
caddr_t
clock_t
daddr_t
dev_t
errno_t
fd_mask
fixpt_t
fsblkcnt_t
fsfilcnt_t
gid_t
id_t
in_addr_t
in_port_t
ino64_t
ino_t
int16_t
int32_t
int64_t
int8_t
int_fast16_t
int_fast32_t
int_fast64_t
int_fast8_t
int_least16_t
int_least32_t
int_least64_t
int_least8_t
intmax_t
intptr_t
key_t
mode_t
nlink_t
off_t
pid_t
pthread_key_t
ptrdiff_t
qaddr_t
quad_t
register_t
rlim_t
rsize_t
sa_family_t
sae_associd_t
sae_connid_t
segsz_t
size_t
socklen_t
ssize_t
suseconds_t
swblk_t
syscall_arg_t
time_t
u_char
u_int
u_int16_t
u_int32_t
u_int64_t
u_int8_t
u_long
u_quad_t
u_short
uid_t
uint16_t
uint32_t
uint64_t
uint8_t
uint_fast16_t
uint_fast32_t
uint_fast64_t
uint_fast8_t
uint_least16_t
uint_least32_t
uint_least64_t
uint_least8_t
uintmax_t
uintptr_t
useconds_t
user_addr_t
user_long_t
user_off_t
user_size_t
user_ssize_t
user_time_t
user_ulong_t
wchar_t
```

### Windows Types

```
__time32_t
__time64_t
_dev_t
_ino_t
_mode_t
_off64_t
_off_t
_pid_t
_sigset_t
dev_t
errno_t
ino_t
int16_t
int32_t
int64_t
int8_t
int_fast16_t
int_fast32_t
int_fast64_t
int_fast8_t
int_least16_t
int_least32_t
int_least64_t
int_least8_t
intmax_t
intptr_t
long
mode_t
off32_t
off64_t
off_t
pid_t
ptrdiff_t
rsize_t
size_t
ssize_t
time_t
uint16_t
uint64_t
uint8_t
uint_fast16_t
uint_fast32_t
uint_fast64_t
uint_fast8_t
uint_least16_t
uint_least64_t
uint_least8_t
uintmax_t
uintptr_t
ulong
useconds_t
wchar_t
wctype_t
wint_t
```

### FreeBSD Types

```
__clock_t
__clockid_t
__cpuid_t
__dev_t
__fd_mask
__fixpt_t
__gid_t
__id_t
__in_addr_t
__in_port_t
__ino_t
__int16_t
__int32_t
__int64_t
__int8_t
__int_fast16_t
__int_fast32_t
__int_fast64_t
__int_fast8_t
__int_least16_t
__int_least32_t
__int_least64_t
__int_least8_t
__intmax_t
__intptr_t
__key_t
__mode_t
__nlink_t
__off_t
__paddr_t
__pid_t
__psize_t
__ptrdiff_t
__register_t
__rlim_t
__rune_t
__sa_family_t
__segsz_t
__size_t
__socklen_t
__ssize_t
__suseconds_t
__swblk_t
__time_t
__timer_t
__uid_t
__uint16_t
__uint32_t
__uint64_t
__uint8_t
__uint_fast16_t
__uint_fast32_t
__uint_fast64_t
__uint_fast8_t
__uint_least16_t
__uint_least32_t
__uint_least64_t
__uint_least8_t
__uintmax_t
__uintptr_t
__useconds_t
__vaddr_t
__vsize_t
__wchar_t
__wctrans_t
__wctype_t
__wint_t
caddr_t
clock_t
clockid_t
cpuid_t
daddr32_t
daddr64_t
daddr_t
dev_t
fixpt_t
gid_t
id_t
in_addr_t
in_port_t
ino_t
int16_t
int32_t
int64_t
int8_t
intptr_t
key_t
mode_t
nlink_t
off_t
paddr_t
pid_t
psize_t
qaddr_t
quad_t
register_t
rlim_t
sa_family_t
segsz_t
size_t
socklen_t
ssize_t
suseconds_t
swblk_t
time_t
timer_t
u_char
u_int
u_int16_t
u_int32_t
u_int64_t
u_int8_t
u_long
u_quad_t
u_short
uid_t
uint16_t
uint32_t
uint64_t
uint8_t
uintptr_t
ulong
unchar
useconds_t
vaddr_t
vsize_t
```

### OpenBSD Types

```
__blkcnt_t
__blksize_t
__clock_t
__clockid_t
__cpuid_t
__dev_t
__fd_mask
__fixpt_t
__fsblkcnt_t
__fsfilcnt_t
__gid_t
__id_t
__in_addr_t
__in_port_t
__ino_t
__int16_t
__int32_t
__int64_t
__int8_t
__int_fast16_t
__int_fast32_t
__int_fast64_t
__int_fast8_t
__int_least16_t
__int_least32_t
__int_least64_t
__int_least8_t
__intmax_t
__intptr_t
__key_t
__mode_t
__nlink_t
__off_t
__paddr_t
__pid_t
__psize_t
__ptrdiff_t
__register_t
__rlim_t
__rune_t
__sa_family_t
__segsz_t
__size_t
__socklen_t
__ssize_t
__suseconds_t
__swblk_t
__time_t
__timer_t
__uid_t
__uint16_t
__uint32_t
__uint64_t
__uint8_t
__uint_fast16_t
__uint_fast32_t
__uint_fast64_t
__uint_fast8_t
__uint_least16_t
__uint_least32_t
__uint_least64_t
__uint_least8_t
__uintmax_t
__uintptr_t
__useconds_t
__vaddr_t
__vsize_t
__wchar_t
__wctrans_t
__wctype_t
__wint_t
blkcnt_t
blksize_t
caddr_t
clock_t
clockid_t
cpuid_t
daddr32_t
daddr_t
dev_t
fixpt_t
fsblkcnt_t
fsfilcnt_t
gid_t
id_t
in_addr_t
in_port_t
ino_t
int16_t
int32_t
int64_t
int8_t
key_t
mode_t
nlink_t
off_t
paddr_t
pid_t
psize_t
qaddr_t
quad_t
register_t
rlim_t
sa_family_t
segsz_t
sigset_t
size_t
socklen_t
ssize_t
suseconds_t
swblk_t
time_t
timer_t
u_char
u_int
u_int16_t
u_int32_t
u_int64_t
u_int8_t
u_long
u_quad_t
u_short
uid_t
uint16_t
uint32_t
uint64_t
uint8_t
ulong
unchar
useconds_t
vaddr_t
vsize_t
```

### NetBSD Types

```
__clock_t
__clockid_t
__cpuid_t
__dev_t
__fd_mask
__fixpt_t
__gid_t
__id_t
__in_addr_t
__in_port_t
__ino_t
__int16_t
__int32_t
__int64_t
__int8_t
__int_fast16_t
__int_fast32_t
__int_fast64_t
__int_fast8_t
__int_least16_t
__int_least32_t
__int_least64_t
__int_least8_t
__intmax_t
__intptr_t
__key_t
__mode_t
__nlink_t
__off_t
__paddr_t
__pid_t
__psize_t
__ptrdiff_t
__register_t
__rlim_t
__rune_t
__sa_family_t
__segsz_t
__size_t
__socklen_t
__ssize_t
__suseconds_t
__swblk_t
__time_t
__timer_t
__uid_t
__uint16_t
__uint32_t
__uint64_t
__uint8_t
__uint_fast16_t
__uint_fast32_t
__uint_fast64_t
__uint_fast8_t
__uint_least16_t
__uint_least32_t
__uint_least64_t
__uint_least8_t
__uintmax_t
__uintptr_t
__useconds_t
__vaddr_t
__vsize_t
__wchar_t
__wctrans_t
__wctype_t
__wint_t
caddr_t
clock_t
clockid_t
cpuid_t
daddr32_t
daddr64_t
daddr_t
dev_t
fixpt_t
gid_t
id_t
in_addr_t
in_port_t
ino_t
int16_t
int32_t
int64_t
int8_t
intptr_t
key_t
mode_t
nlink_t
off_t
paddr_t
pid_t
psize_t
qaddr_t
quad_t
register_t
rlim_t
sa_family_t
segsz_t
size_t
socklen_t
ssize_t
suseconds_t
swblk_t
time_t
timer_t
u_char
u_int
u_int16_t
u_int32_t
u_int64_t
u_int8_t
u_long
u_quad_t
u_short
uid_t
uint
uint16_t
uint32_t
uint64_t
uint8_t
uintptr_t
ulong
unchar
useconds_t
ushort
vaddr_t
vsize_t
```

## EXAMPLES

Packs a single value and print it to stdout:

    $ ronin pack uint32:1337 | hexdump -C

Packs multiple values and prints them to stdout:

    $ ronin pack uint32:1337 int32:-2 char:A string:hello | hexdump -C
    00000000  39 05 00 00 fe ff ff ff  41 68 65 6c 6c 6f 00     |9.......Ahello.|
    0000000f

Packs multiple values and write them to an output file:

    $ ronin pack -o file.bin uint32:1337 int32:-2 char:A --string hello

Packs values in big endian:

    $ ronin pack --endian big uint32:1337 int32:-2 | hexdump -C
    00000000  00 00 05 39 ff ff ff fe                           |...9....|
    00000008

Packs values for the ARM (big-endian) architecture:

    $ ronin pack --arch arm_be uint32:0x12345678 | hexdump -C
    00000000  12 34 56 78                                       |.4Vx|
    00000004

Packs values for the ARM (little-endian) architecture:

    $ ronin pack --arch arm_le uint32:0x12345678 | hexdump -C
    00000000  78 56 34 12                                       |xV4.|
    00000004

Packs values for Windows (x86-64):

    $ ronin pack --arch x86_64 --os windows uint:0x11223344 | hexdump -C
    00000000  44 33 22 11                                       |D3".|
    00000004

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-unpack](ronin-unpack.1.md)
