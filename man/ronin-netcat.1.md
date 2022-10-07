# ronin-netcat 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin netcat` [*options*] [`--tcp` \| `--udp` \| `--ssl` \| `--tls`] {*HOST* *PORT* \| `-l` [*HOST*] *PORT* \| `--unix` *PATH*}

## DESCRIPTION

Connects to or listens on a TCP/UDP/SSL/TLS/UNIX socket.

## ARGUMENTS

*HOST*
  The remote hostname or IP address to connect to or the local hostname or IP
  address to listen on.

*PORT*
  The remote port to connect to or the local port to listen on.

*PATH*
  The path to the UNIX socket to connect to or listen on.

## OPTIONS

`-v`, `--verbose`
  Enables verbose output.

`--tcp`
  Uses the TCP protocol.

`--udp`
  Uses the UDP protocol.

`-U`, `--unix` *PATH*
  Uses the UNIX socket protocol and connects to or listens on the given *PATH*.

`-l`, `--listen`
  Listens for incoming connections.

`-s`, `--source` *HOST*
  Source address to bind to.

`-p`, `--source-port` *PORT*
  Source port to bind to.

`-b`, `--buffer-size` *INT*
  Buffer size to use. Defaults to 4096 if not given.

`-x`, `--hexdump`
  Hexdumps each message that is received.

`--ssl`
  Enables SSL mode.

`--tls`
  Enables TLS mode.

`--ssl-version` `1`\|`1.1`\|`1.2`
  Specifies the required SSL version.

`--ssl-cert` *FILE*
  Specifies the SSL certificate file.

`--ssl-key` *FILE*
  Specifies the SSL key file.

`--ssl-verify` `none`\|`peer`\|`fail_if_no_peer_cert`\|`client_once`\|`true`\|`false`
  SSL verification mode.

`--ssl-ca-bundle` *PATH*
  Path to the file or directory of CA certificates.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-hexdump(1) ronin-http(1)
