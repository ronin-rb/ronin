= Ronin

* http://ronin.rubyforge.org/
* http://github.com/postmodern/ronin
* irc.freenode.net #ronin
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

=== Ruby

Ronin's Ruby environment allows security researchers to leverage Ruby with
ease. The Ruby environment contains a multitude of convenience methods
for working with data in Ruby, a Ruby Object Database, a customized Ruby
Console and an extendable command-line interface.

=== Extend

Ronin's more specialized features are provided by additional Ronin
libraries, which users can choose to install. These libraries can allow
one to write and run Exploits and Payloads, scan for PHP vulnerabilities,
perform Google Dorks  or run 3rd party scanners.

=== Publish

Ronin allows users to publish and share code, exploits, payloads or other
data via Overlays. Overlays are directories of code and data that can be
hosted on any SVN, Hg, Git or Rsync server. Ronin makes it easy to create,
install or update Overlays.

== FEATURES:

* Supports installing/updating/uninstalling of Overlays.
  * Supports accessing Overlays from various media types:
    * Subversion (SVN)
    * Mercurial (Hg)
    * Git
    * Rsync
* Allows for the loading of Extensions from one or more Overlays.
* Provides persistent storage of objects using DataMapper.
* Caches and mirrors objects stored in Overlays using DataMapper.
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
  * print_info, print_error, print_warning and print_debug output helper
    methods with color-output.
* Provides an extendable command-line interface based on Thor.

== SYNOPSIS:

* Install an Overlay:

    $ ronin install svn://example.com/path/to/overlay

* List installed Overlays:

    $ ronin list

* Update all installed Overlays:

    $ ronin update

* Update a specific Overlay:

    $ ronin update overlay-name

* Uninstall an Overlay:

    $ ronin uninstall overlay-name

* Start the Ronin console:

    $ ronin

* View available commands:

    $ ronin help

== REQUIREMENTS:

* {nokogiri}[http://nokogiri.rubyforge.org/] >= 1.2.0
  * {libxml2}[http://xmlsoft.org/]
  * {libxslt1}[http://xmlsoft.org/XSLT/]
* {DataMapper}[http://datamapper.org/]:
  * extlib >= 0.9.12
  * dm-core >= 0.9.11
  * data_objects >= 0.9.11
  * do_sqlite3 >= 0.9.11
    * {libsqlite3}[http://sqlite.org/]
  * dm-types >= 0.9.11
  * dm-serializer >= 0.9.11
  * dm-validations >= 0.9.11
* {dm-predefined}[http://dm-predefined.rubyforge.org/] >= 0.1.0
* {parameters}[http://parameters.rubyforge.org/] >= 0.1.5
* {contextify}[http://contextify.rubyforge.org/] >= 0.1.2
* {reverse-require}[http://reverserequire.rubyforge.org/] >= 0.3.1
* {repertoire}[http://repertoire.rubyforge.org/] >= 0.2.1
* thor >= 0.11.5

== INSTALL:

  $ sudo gem install ronin

== RONIN LIBRARIES:

=== Ronin ASM

* http://ronin.rubyforge.org/asm/
* http://github.com/postmodern/ronin-asm

Ronin ASM is a Ruby library for Ronin that provides dynamic Assembly (ASM)
generation of programs or shellcode.

=== Ronin Dorks

* http://ronin.rubyforge.org/dorks/
* http://github.com/postmodern/ronin-dorks

Ronin Dorks is a Ruby library for Ronin that provides support for various
Google (tm) Dorks functionality.

=== Ronin Exploits

* http://ronin.rubyforge.org/exploits/
* http://github.com/postmodern/ronin-exploits

Ronin Exploits is a Ruby library for Ronin that provides exploitation and
payload crafting functionality.

=== Ronin Gen

* http://ronin.rubyforge.org/gen/
* http://github.com/postmodern/ronin-gen

Ronin Gen is a Ruby library for Ronin that provides various generators.

=== Ronin SQL

* http://ronin.rubyforge.org/sql/
* http://github.com/postmodern/ronin-sql

Ronin SQL is a Ruby library for Ronin that provids support for SQL related
security tasks, such as scanning for and exploiting SQL injections.

=== Ronin PHP

* http://ronin.rubyforge.org/php/
* http://github.com/postmodern/ronin-php

Ronin PHP is a Ruby library for Ronin that provides support for PHP related
security tasks, such as finding and exploiting Local File Inclusion (LFI)
and Remote File Inclusion (RFI).

=== Ronin Web

* http://ronin.rubyforge.org/web/
* http://github.com/postmodern/ronin-web

Ronin Web is a Ruby library for Ronin that provides support for web
scraping and spidering functionality.

== LICENSE:

Ronin - A Ruby platform for exploit development and security research.

Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)

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
