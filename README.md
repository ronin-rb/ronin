# ronin

[![CI](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin.svg)](https://codeclimate.com/github/ronin-rb/ronin)
[![Gem Version](https://badge.fury.io/rb/ronin.svg)](https://badge.fury.io/rb/ronin)

* [Website](https://ronin-rb.dev)
* [Source](https://github.com/ronin-rb/ronin)
* [Issues](https://github.com/ronin-rb/ronin/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

[Ronin][website] is a free and Open Source [Ruby] toolkit for security research
and development. Ronin contains many different [CLI commands](#synopsis) and
[Ruby libraries][ronin-rb] for a variety of security tasks, such as
encoding/decoding data, filter IPs/hosts/URLs, querying ASNs, querying DNS,
HTTP, [scanning for web vulnerabilities][ronin-vulns-synopsis],
[spidering websites][ronin-web-spider],
[installing 3rd-party repositories][ronin-repos-synopsis] of
[exploits][ronin-exploits] and/or
[payloads][ronin-payloads], [running exploits][ronin-exploits-synopsis],
[developing new exploits][ronin-exploits-examples],
[managing local databases][ronin-db-synopsis],
[fuzzing data][ronin-fuzzer], and much more.

### Who is Ronin for?

* CTF players
* Bug bounty hunters
* Security Researchers
* Security Engineers
* Developers
* Students

### What does Ronin provide?

* A toolkit of useful commands.
* A fully-loaded Ruby REPL.
* An ecosystem of high-quality security related Ruby libraries, APIs, and
  commands.

### What can you do with Ronin?

* Quickly process and query various data using the `ronin` commands.
* Efficiently work with code and data in the `ronin irb` Ruby REPL.
* Rapidly prototype Ruby scripts using [ronin-support] and other `ronin`
  libraries.
* Install 3rd-party [git] repositories of exploits, payloads, or other code,
  using [ronin-repos].
* Import and query data using the [ronin-db] database.
* Fuzz data using [ronin-fuzzer].
* Use common payloads or write your own using [ronin-payloads].
* Write/run exploits using [ronin-exploits].
* Scan for web vulnerabilities using [ronin-vulns].

## Synopsis

```
Usage: ronin [options] [COMMAND [ARGS...]]

Options:
    -h, --help                       Print help information

Arguments:
    [COMMAND]                        The command name to run
    [ARGS ...]                       Additional arguments for the command

Commands:
    asn
    banner-grab
    bitflip
    cert-dump
    cert-gen
    cert-grab
    decode, dec
    decrypt
    dns
    email-addr
    encode, enc
    encrypt
    entropy
    escape
    extract
    grep
    help
    hexdump
    highlight
    hmac
    homoglyph
    host
    http
    ip
    iprange
    irb
    md5
    netcat, nc
    new
    proxy
    public-suffix-list
    quote
    rot
    sha1
    sha256
    sha512
    strings
    tld-list
    tips
    typo
    typosquat
    unescape
    unhexdump
    unquote
    url
    xor

Additional Ronin Commands:
    $ ronin-repos
    $ ronin-db
    $ ronin-web
    $ ronin-fuzzer
    $ ronin-payloads
    $ ronin-exploits
    $ ronin-vulns
```

List ronin commands:

```shell
$ ronin help
```

View a man-page for a command:

```shell
$ ronin help COMMAND
```

Get a random tip on how to use `ronin`:

```shell
$ ronin tips
```

Open the Ronin Ruby REPL:

```
$ ronin irb
                                                                   , Jµ     ▓▓█▓
                                                  J▌      ▐▓██▌ ████ ██    ▐███D
                                      ╓▄▓▓█████▌  ██µ     ████ ▄███ÖJ██▌   ███▌
        ,╓µ▄▄▄▄▄▄▄▄µ;,            ,▄▓██████████  ▐███    ▐███▀ ███▌ ████µ ▄███
¬∞MÆ▓███████████████████████▓M  ▄██████▀▀╙████▌  ████▌   ████ ▄███ J█████ ███▌
           `█████▀▀▀▀▀███████  -████▀└    ████  ▐█████n ▄███O ███▌ ██████████
           ▓████L       ████▀  ▓████     ▓███Ö  ███████ ███▌ ▓███ ▐█████████▀
          ▄████▀  ,╓▄▄▄█████  J████Ü    ,███▌  ▄███████████ J███▀ ████ █████
         J█████████████████─  ████▌     ████   ████`██████▌ ████ ▐███Ü ▐███Ü
         ███████████▀▀▀╙└    ▐████     J███▌  ▓███▌ ²█████ J███Ü ███▌   ▀█▌
        ▓██████████▌         ████▌     ████  ;████   ▀███▀ ███▌ J▀▀▀-    █
       ▄█████▀ ▀█████µ      ▐████  ,▄▓████▀  ████▀    ███ J███           `
      J█████-    ╙▀███▄     ████████████▀╙  J█▀▀▀      █U  ▀█▌
      ████▀         ▀███   ▄████████▀▀                 ╨    █
     ▓██▀             ²▀█▄ █▀▀▀╙└
    ▄██╜                 ╙W
   J█▀
   ▌└
  ┘

irb(ronin)>
```

### Binary

Hexdumps data in a variety of formats:

```shell
$ ronin hexdump /bin/ls
```

Un-hexdumps a hexdump file back into it's original raw binary data:

```shell
$ ronin unhexdump -o data.bin hexdump.txt
```

Print all printable strings from a file:

```shell
$ ronin strings /bin/ls
```

Print all alphabetic strings from a file:

```shell
$ ronin strings --alpha /bin/ls
```

Print all alpha-numeric strings from a file:

```shell
$ ronin strings --alpha-num /bin/ls
```

Print all numeric strings from a file:

```shell
$ ronin strings --numeric /bin/ls
```

Print all hexadecimal strings from a file:

```shell
$ ronin strings --hex /bin/ls
```

Enumerate through all of the Bit-flips of a domain name:

```shell
$ ronin bitflip microsoft --alpha-num --append .com
licrosoft.com
oicrosoft.com
iicrosoft.com
eicrosoft.com
Microsoft.com
mhcrosoft.com
mkcrosoft.com
mmcrosoft.com
macrosoft.com
mycrosoft.com
...
```

### Encoding

Base64 encode a string:

```shell
$ ronin encode --base64 --string "foo bar baz"
Zm9vIGJhciBiYXo=
```

Zlib compresses, Base64 encodes, and then URI encode a string:

```shell
$ ronin encode --zlib --base64 --uri --string "foo bar"
%65%4A%78%4C%79%38%39%58%53%45%6F%73%41%67%41%4B%63%41%4B%61%0A
```

Base64 decode a string:

```shell
$ ronin decode --base64 --string "Zm9vIGJhciBiYXo="
foo bar baz
```

URI decode, Base64 decode, and then zlib inflates a string:

```shell
$ ronin decode --uri --base64 --zlib --string "%65%4A%78%4C%79%38%39%58%53%45%6F%73%41%67%41%4B%63%41%4B%61%0A"
foo bar
```

URI escape a string:

```shell
$ ronin escape --uri --string "foo bar"
foo%20bar
```

URI unescape a string:

```shell
$ ronin unescape --uri --string "foo%20bar"
foo bar
```

Convert a file into a quoted C string:

```shell
$ ronin quote --c file.bin
"..."
```

Convert a file into a quoted JavaScript string:

```shell
$ ronin quote --js file.bin
```

Unquote a C string:

```shell
$ ronin unquote --c --string '"\x66\x6f\x6f\x20\x62\x61\x72"'
foo bar
```

### Text

Extract high-entropy data from a file:

```shell
$ ronin entropy -e 5.0 index.html
```

Grep for common patterns of data:

```shell
$ ronin grep --hash index.html
```

Extract common patterns from data:

```shell
$ ronin extract --hash index.html
```

Generate a random typo of a word:

```shell
$ ronin typo microsoft
microssoft
```

Enumerate over every typo variation of a word:

```shell
$ ronin typo --enum microsoft
microosoft
microsooft
microssoft
```

Generate a random homoglyph version of a word:

```shell
$ ronin homoglyph CEO
CＥO
```

Enumerate over every homoglyph variation of a word:

```shell
$ ronin homoglyph --enum CEO
ϹEO
СEO
ⅭEO
ＣEO
CΕO
CЕO
CＥO
CEΟ
CEО
CEＯ
```

Syntax-highlights a file:

```shell
$ ronin highlight index.html
```

### Cryptography

AES-256 encrypt a file:

```shell
$ ronin encrypt --cipher aes-256-cbc --password "..." file.txt > encrypted.bin
```

Decrypt data:

```shell
$ ronin decrypt --cipher aes-256-cbc --password "..." encrypted.bin
```

Generates a HMAC for a file:

```shell
$ ronin hmac --hash sha1 --password "too many secrets" data.txt
```

Generates a HMAC for a string:

```shell
$ ronin hmac --hash sha1 --password "too many secrets" --string "..."
```

Calculate an MD5 checksum of a string:

```shell
$ ronin md5 --string "hello world"
5eb63bbbe01eeed093cb22bb8f5acdc3
```

Calculate the MD5 checksum of a file:

```shell
$ ronin md5 file.txt
```

Calculate the MD5 checksum of every line in a file:

```shell
$ ronin md5 --multiline file.txt
```

Calculate an SHA1 checksum of a string:

```shell
$ ronin sha1 --string "hello world"
2aae6c35c94fcfb415dbe95f408b9ce91ee846ed
```

Calculate the SHA1 checksum of a file:

```shell
$ ronin sha1 file.txt
```

Calculate the SHA1 checksum of every line in a file:

```shell
$ ronin sha1 --multiline file.txt
```

Calculate an SHA256 checksum of a string:

```shell
$ ronin sha256 --string "hello world"
b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9
```

Calculate the SHA256 checksum of a file:

```shell
$ ronin sha256 file.txt
```

Calculate the SHA256 checksum of every line in a file:

```shell
$ ronin sha256 --multiline file.txt
```

Calculate an SHA512 checksum of a string:

```shell
$ ronin sha512 --string "hello world"
309ecc489c12d6eb4cc40f50c902f2b4d0ed77ee511a7c7a9bcd3ca86d4cd86f989dd35bc5ff499670da34255b45b0cfd830e81f605dcf7dc5542e93ae9cd76f
```

Calculate the SHA512 checksum of a file:

```shell
$ ronin sha512 file.txt
```

Calculate the SHA512 checksum of every line in a file:

```shell
$ ronin sha512 --multiline file.txt
```

ROT-13 encodes a string:

```shell
$ ronin rot --string "The quick brown fox jumps over the lazy dog"
Gur dhvpx oebja sbk whzcf bire gur ynml qbt
```

XOR encodes a string:

```shell
$ ronin xor --key ABC --string "The quick brown fox jumps over the lazy dog"
"\x15*&a36(!(a 1.5-a$,9b)4/32b,7'1a6+$b/ 8:a&,&"
```

### Networking

Query the ASN of an IP address:

```shell
$ ronin asn -I 4.2.2.1
4.0.0.0/9 AS3356 (US) LEVEL3
```

Get the system's external/public IP address:

```shell
$ ronin ip --public
```

Convert an IP address to decimal format:

```shell
$ ronin ip --decimal 127.0.0.1
2130706433
```

Convert a file of IP addresses into URLs:

```shell
$ ronin ip --file targets.txt --http
```

Enumerate over every IP address in the IP CIDR range:

```shell
$ ronin iprange 10.1.0.0/15
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.6
10.0.0.7
10.0.0.8
10.0.0.9
...
```

Enumerate over every IP address in the IP glob range:

```shell
$ ronin iprange 10.1-3.0.*
10.1.0.1
10.1.0.2
10.1.0.3
10.1.0.4
10.1.0.5
10.1.0.6
10.1.0.7
10.1.0.8
10.1.0.9
10.1.0.10
...
```

Enumerate over every IP address between two IP addresses:

```shell
$ ronin iprange --start 10.0.0.1 --stop 10.0.3.33
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.6
10.0.0.7
10.0.0.8
10.0.0.9
10.0.0.10
```

Connect to a remote TCP service:

```shell
$ ronin netcat -v example.com 80
```

Listen on a local TCP port:

```shell
$ ronin netcat -v -l 1337
```

Connect to a remote SSL/TLS service:

```shell
$ ronin netcat -v --ssl example.com 443
```

Connect to a remote UDP service:

```shell
$ ronin netcat -v -u example.com 1337
```

Listen on a local UDP port:

```shell
$ ronin netcat -v -u -l 1337
```

Opens a UNIX socket:

```shell
$ ronin netcat -v --unix /path/to/unix.socket
```

Hexdump all data received from a socket:

```shell
$ ronin netcat --hexdump example.com 80
GET / HTTP/1.1
Host: example.com
User-Agent: Ruby

00000000  48 54 54 50 2f 31 2e 31 20 32 30 30 20 4f 4b 0d  |HTTP/1.1 200 OK.|
00000010  0a 41 67 65 3a 20 32 35 30 38 30 36 0d 0a 43 61  |.Age: 250806..Ca|
00000020  63 68 65 2d 43 6f 6e 74 72 6f 6c 3a 20 6d 61 78  |che-Control: max|
00000030  2d 61 67 65 3d 36 30 34 38 30 30 0d 0a 43 6f 6e  |-age=604800..Con|
00000040  74 65 6e 74 2d 54 79 70 65 3a 20 74 65 78 74 2f  |tent-Type: text/|
00000050  68 74 6d 6c 3b 20 63 68 61 72 73 65 74 3d 55 54  |html; charset=UT|
...
```

#### DNS

Query DNS records:

```shell
$ ronin dns -t TXT github.com
```

Find all registered TLDs for a host name:

```shell
$ ronin host --enum-tlds --registered github.com
github.ac
github.actor
github.ae
github.africa
github.agency
github.ai
...
```

Find all registered public suffixes for a host name:

```shell
$ ronin host --enum-suffix --registered github.com
example.com.ag
example.ai
example.al
example.am
example.com.ar
example.at
example.co.at
example.or.at
example.com.au
example.be
example.com.bh
...
```

Find all subdomains that have addresses:

```shell
$ ronin host --enum-subdomains subdomains.txt --has-addresses google.com
www.google.com
mail.google.com
smtp.google.com
ns1.google.com
ns2.google.com
m.google.com
ns.google.com
blog.google.com
admin.google.com
news.google.com
vpn.google.com
ns3.google.com
...
```

Enumerate over every possible typosquat variation of a domain:

```shell
$ ronin typosquat microsoft.com
microosoft.com
microsooft.com
microssoft.com
```

Find all of the registered typosquat domains for a valid domain:

```shell
$ ronin typosquat --registered microsoft.com
```

Find all of the typosquat domains with addresses for a valid domain:

```shell
$ ronin typosquat --has-addresses microsoft.com
```

Find all of the unregistered typosquat domains for a valid domain:

```shell
$ ronin typosquat --unregistered microsoft.com
```

De-obfuscate an email address:

```shell
$ ronin email-addr --deobfuscate "john [dot] smith [at] example [dot] com"
john.smith@example.com
```

Enumerate through all of the obfuscations of an email address:

```shell
$ ronin email-addr --enum-obfuscations john.smith@example.com
john.smith @ example.com
john.smith AT example.com
john.smith at example.com
john.smith[AT]example.com
john.smith[at]example.com
...
```

#### SSL/TLS Certs

Dump information about a SSL/TLS certificate:

```shell
$ ronin cert-dump https://example.com/
```

Download a SSL/TLS certificate from a host and port:

```shell
$ ronin cert-grab github.com:443
```

Generate a new SSL/TLS certificate:

```shell
$ ronin cert-gen -c test.com -O "Test Co" -U "Test Dept" \
                 -L "Test City" -S NY -C US
```

#### HTTP

Perform an HTTP `GET` request (with syntax highlighting):

```shell
$ ronin http https://example.com/
```

Send an HTTP request with additional headers:

```shell
$ ronin http --post --header "Authorization: ..." https://foo.bar/
```

Send an HTTP request with a known `User-Agent` string:

```shell
$ ronin http --post --user-agent chrome-android https://foo.bar/
```

Send an HTTP request with a custom `User-Agent` string:

```shell
$ ronin http --post --user-agent-string "..." https://foo.bar/
```

Open an interactive HTTP shell:

```shell
$ ronin http --shell https://example.com/
https://example.com/> help
  help [COMMAND]                      	Prints the list of commands or additional help
  get PATH[?QUERY] [BODY]             	Performs a GET request
  head PATH[?QUERY]                   	Performs a HEAD request
  patch PATH[?QUERY] [BODY]           	Performs a PATCH request
  post PATH[?QUERY] [BODY]            	Performs a POST request
  put PATH [BODY]                     	Performs a PUT request
  copy PATH DEST                      	Performs a COPY request
  delete PATH[?QUERY]                 	Performs a DELETE request
  lock PATH[?QUERY]                   	Performs a LOCK request
  options PATH[?QUERY]                	Performs a OPTIONS request
  mkcol PATH[?QUERY]                  	Performs a MKCOL request
  move PATH[?QUERY] DEST              	Performs a MOVE request
  propfind PATH[?QUERY]               	Performs a PROPFIND request
  proppatch PATH[?QUERY]              	Performs a PROPPATCH request
  trace PATH[?QUERY]                  	Performs a TRACE request
  unlock PATH[?QUERY]                 	Performs a UNLOCK request
  cd PATH                             	Changes the base URL path
  headers [{set | unset} NAME [VALUE]]	Manages the request headers
```

Print the HTTP status of every URL in a file:

```shell
$ ronin url --file urls.txt --status
```

### Generators

Generate a new Ruby script with [ronin-support] preloaded:

```shell
$ ronin new script foo.rb
```

Generate a new Ruby project with a `Gemfile`:

```shell
$ ronin new project foo
```

Generate a new [nokogiri] Ruby script for parsing HTML/XML:

[nokogiri]: https://nokogiri.org/

```shell
$ ronin new nokogiri foo.rb
```

Generate a new [ronin-web-server] Ruby script:

```shell
$ ronin new web-server my_server.rb
```

Generate a new [ronin-web-server] based web app:

```shell
$ ronin new web-app my_app
```

Generate a new [ronin-web-spider] Ruby script:

```shell
$ ronin new web-spider --host=example.com my_spider.rb
```

Generate a [ronin-listener-dns] script:

```shell
$ ronin new dns-listener my_dns_listener.rb
```

Generate a [ronin-dns-proxy] script:

```shell
$ ronin new dns-proxy my_dns_proxy.rb
```

Generate a [ronin-listener-http] script:

```shell
$ ronin new http-listener my_http_listener.rb
```

Generate a [ronin-exploits] script:

```shell
$ ronin new exploit my_exploit.rb
```

Generate a [ronin-payloads] script:

```shell
$ ronin new payload my_payload.rb
```

### See Also

* [ronin-repos](https://github.com/ronin-rb/ronin-repos#synopsis)
* [ronin-db](https://github.com/ronin-rb/ronin-db#synopsis)
* [ronin-web](https://github.com/ronin-rb/ronin-web#synopsis)
* [ronin-fuzzer](https://github.com/ronin-rb/ronin-fuzzer#synopsis)
* [ronin-payloads](https://github.com/ronin-rb/ronin-payloads#synopsis)
* [ronin-exploits](https://github.com/ronin-rb/ronin-exploits#synopsis)
* [ronin-vulns](https://github.com/ronin-rb/ronin-vulns#synopsis)

## Requirements

* [gcc] / [clang]
* [make]
* [git]
* [libsqlite3]
* [Ruby] >= 3.0.0
* [open_namespace] ~> 0.4
* [rouge] ~> 3.0
* [async-io] ~> 1.0
* [wordlist] ~> 1.1
* [ronin-support] ~> 1.1
* [ronin-dns-proxy] ~> 0.1
* [ronin-core] ~> 0.2
* [ronin-repos] ~> 0.1
* [ronin-db] ~> 0.1
* [ronin-listener] ~> 0.1
* [ronin-nmap] ~> 0.1
* [ronin-masscan] ~> 0.1
* [ronin-recon] ~> 0.1
* [ronin-fuzzer] ~> 0.1
* [ronin-web] ~> 2.0
* [ronin-code-asm] ~> 1.0
* [ronin-code-sql] ~> 2.0
* [ronin-payloads] ~> 0.1
* [ronin-exploits] ~> 1.0
* [ronin-vulns] ~> 0.1

## Install

### Bash Script

```shell
curl -o ronin-install.sh https://raw.githubusercontent.com/ronin-rb/scripts/main/ronin-install.sh && bash ronin-install.sh
```

### Manually

See the [manual install][manual-instructions] instructions for how to install
Ronin and it's additional dependencies on your platform.

[manual-instructions]: https://ronin-rb.dev/install/#manual-instructions

### Docker

If you prefer using [Docker], there are also [Docker images] available:

```shell
docker pull roninrb/ronin
docker run -it roninrb/ronin
```

Additionally, if you want to mount your home directory into the docker image:

```shell
docker run --mount type=bind,source="$HOME",target=/home/ronin -it ronin
```

[Docker]: https://www.docker.com/
[Docker images]: https://hub.docker.com/r/roninrb/ronin

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin/fork)
2. Clone It!
3. `cd ronin`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)

Ronin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin.  If not, see <https://www.gnu.org/licenses/>.

[website]: https://ronin-rb.dev/
[ronin-rb]: https://github.com/ronin-rb/

[gcc]: http://gcc.gnu.org/
[clang]: http://clang.llvm.org/
[git]: https://git-scm.com/
[make]: https://www.gnu.org/software/automake/
[libsqlite3]: https://www.sqlite.org/index.html
[Ruby]: https://www.ruby-lang.org
[open_namespace]: https://github.com/postmodern/open_namespace#readme
[rouge]: https://github.com/rouge-ruby/rouge#readme
[async-io]: https://github.com/socketry/async-io#readme
[wordlist]: https://github.com/postmodern/wordlist.rb#readme

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-dns-proxy]: https://github.com/ronin-rb/ronin-dns-proxy#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-repos-synopsis]: https://github.com/ronin-rb/ronin-repos#synopsis
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-db-synopsis]: https://github.com/ronin-rb/ronin-db#synopsis
[ronin-listener]: https://github.com/ronin-rb/ronin-listener#readme
[ronin-listener-dns]: https://github.com/ronin-rb/ronin-listener-dns#readme
[ronin-listener-http]: https://github.com/ronin-rb/ronin-listener-http#readme
[ronin-nmap]: https://github.com/ronin-rb/ronin-nmap#readme
[ronin-masscan]: https://github.com/ronin-rb/ronin-masscan#readme
[ronin-recon]: https://github.com/ronin-rb/ronin-recon#readme
[ronin-fuzzer]: https://github.com/ronin-rb/ronin-fuzzer#readme
[ronin-web]: https://github.com/ronin-rb/ronin-web#readme
[ronin-web-server]: https://github.com/ronin-rb/ronin-web-server#readme
[ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
[ronin-web-user_agents]: https://github.com/ronin-rb/ronin-web-user_agents#readme
[ronin-code-asm]: https://github.com/ronin-rb/ronin-code-asm#readme
[ronin-code-sql]: https://github.com/ronin-rb/ronin-code-sql#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-exploits-synopsis]: https://github.com/ronin-rb/ronin-exploits#synopsis
[ronin-exploits-examples]: https://github.com/ronin-rb/ronin-exploits#examples
[ronin-vulns]: https://github.com/ronin-rb/ronin-vulns#readme
[ronin-vulns-synopsis]: https://github.com/ronin-rb/ronin-vulns#synopsis
