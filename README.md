# Ronin

* [ronin.rubyforge.org](http://ronin.rubyforge.org)
* [github.com/postmodern/ronin](http://github.com/postmodern/ronin)
* [github.com/postmodern/ronin/issues](http://github.com/postmodern/ronin/issues)
* [groups.google.com/group/ronin-ruby](http://groups.google.com/group/ronin-ruby)
* irc.freenode.net #ronin

## Description

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

### Ruby

Ronin's Ruby environment allows security researchers to leverage Ruby with
ease. The Ruby environment contains a multitude of convenience methods
for working with data in Ruby, a Ruby Object Database, a customized Ruby
Console and an extendable command-line interface.

### Extend

Ronin's more specialized features are provided by additional Ronin
libraries, which users can choose to install. These libraries can allow
one to write and run Exploits and Payloads, scan for PHP vulnerabilities,
perform Google Dorks  or run 3rd party scanners.

### Publish

Ronin allows users to publish and share code, exploits, payloads or other
data via Overlays. Overlays are directories of code and data that can be
hosted on any SVN, Hg, Git or Rsync server. Ronin makes it easy to create,
install or update Overlays.

## Feature

* Supports installing/updating/uninstalling of Overlays.
  * Supports accessing Overlays from various media types:
    * Subversion (SVN)
    * Mercurial (Hg)
    * Git
    * Rsync
* Allows for the loading of Extensions from one or more Overlays.
* Provides Object Database using DataMapper.
* Caches and mirrors Objects stored in Overlays using DataMapper.
* Provides convenience methods for:
  * Formatting data:
    * Binary
    * Text
    * HTTP
    * URIs
  * Generating random text.
  * Networking:
    * TCP
    * UDP
    * SMTP / ESMTP
    * POP3
    * Imap
    * Telnet
    * HTTP / HTTPS
  * Enumerating IP ranges:
    * IPv4 / IPv6 addresses.
    * CIDR / globbed ranges.
  * (Un-)Hexdumping data.
  * Handling exceptions.
* Provides a customized Ruby Console with:
  * Tab-completion enabled.
  * Auto-indentation enabled.
  * Pretty-Print loaded.
  * `print_info`, `print_error`, `print_warning` and `print_debug`
    output helper methods with color-output.
* Provides an extendable command-line interface based on Thor.

## Synopsis

Install an Overlay:

    $ ronin install svn://example.com/path/to/overlay

List installed Overlays:

    $ ronin list

Update all installed Overlays:

    $ ronin update

Update a specific Overlay:

    $ ronin update overlay-name

Uninstall an Overlay:

    $ ronin uninstall overlay-name

List available Databases:

    $ ronin database

Add a new Database:

    $ ronin database --add team --uri mysql://user:pass@vpn.example.com/db

Remove a Database:

    $ ronin database --remove team

Start the Ronin console:

    $ ronin

View available commands:

    $ ronin help

## Requirements

* [yard](http://yard.soen.ca/) >= 0.2.3.5
* [nokogiri](http://nokogiri.rubyforge.org/) >= 1.3.3
  * [libxml2](http://xmlsoft.org/)
  * [libxslt1](http://xmlsoft.org/XSLT/)
* [DataMapper](http://datamapper.org/):
  * extlib >= 0.9.14
  * data_objects >= 0.10.1
  * do_sqlite3 >= 0.10.1
    * [libsqlite3](http://sqlite.org/)
  * dm-core >= 0.10.2
  * dm-types >= 0.10.2
  * dm-validations >= 0.10.2
* [dm-predefined](http://dm-predefined.rubyforge.org/) >= 0.2.1
* [open-namespace](http://github.com/postmodern/open-namespace) >= 0.1.0
* [static_paths](http://github.com/postmodern/static_paths) >= 0.1.0
* [chars](http://chars.rubyforge.org/) >= 0.1.2
* [contextify](http://contextify.rubyforge.org/) >= 0.1.4
* thor >= 0.13.0
* [ronin-ext](http://ronin.rubyforge.org/) >= 0.1.0

## Install

    $ sudo gem install ronin

## Additional Libraries

### Ronin ASM

* [github.com/postmodern/ronin-asm](http://github.com/postmodern/ronin-asm)

Ronin ASM is a Ruby library for Ronin that provides dynamic Assembly (ASM)
generation of programs or shellcode.

### Ronin Dorks

* [github.com/postmodern/ronin-dorks](http://github.com/postmodern/ronin-dorks)

Ronin Dorks is a Ruby library for Ronin that provides support for various
Google (tm) Dorks functionality.

### Ronin Exploits

* [github.com/postmodern/ronin-exploits](http://github.com/postmodern/ronin-exploits)

Ronin Exploits is a Ruby library for Ronin that provides exploitation and
payload crafting functionality.

### Ronin Gen

* [github.com/postmodern/ronin-gen](http://github.com/postmodern/ronin-gen)

Ronin Gen is a Ruby library for Ronin that provides various generators.

### Ronin SQL

* [github.com/postmodern/ronin-sql](http://github.com/postmodern/ronin-sql)

Ronin SQL is a Ruby library for Ronin that provids support for SQL related
security tasks, such as scanning for and exploiting SQL injections.

### Ronin PHP

* [github.com/postmodern/ronin-php](http://github.com/postmodern/ronin-php)

Ronin PHP is a Ruby library for Ronin that provides support for PHP related
security tasks, such as finding and exploiting Local File Inclusion (LFI)
and Remote File Inclusion (RFI).

### Ronin Web

* [github.com/postmodern/ronin-web](http://github.com/postmodern/ronin-web)

Ronin Web is a Ruby library for Ronin that provides support for web
scraping and spidering functionality.

## License

Ronin - A Ruby platform for exploit development and security research.

Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
