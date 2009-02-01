= Ronin

* http://ronin.rubyforge.org/
* http://github.com/postmodern/ronin
* irc.freenode.net ##ronin
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Ronin is a Ruby platform designed for information security and data
exploration tasks. Ronin allows for the rapid development and distribution
of code over many of the common Source-Code-Management (SCM) systems.

=== Free

All source code within Ronin is licensed under the GPL-2, therefore no user
will ever have to pay for Ronin or updates to Ronin. Not only is the
source code free, the Ronin project will not sell enterprise grade security
snake-oil solutions, give private training classes or later turn Ronin into
commercial software.

=== Modular

Ronin was not designed as one monolithic framework but instead as a
collection of libraries which can be individually installed. This allows
users to pick and choose what functionality they want in Ronin.

=== Decentralized

Ronin does not have a central repository of exploits and payloads which
all developers contribute to. Instead Ronin has Overlays, repositories of
code that can be hosted on any CVS/SVN/Git/Rsync server. Users can then use
Ronin to quickly install or update Overlays. This allows developers and
users to form their own communities, independent of the main developers
of Ronin.

== FEATURES:

* Supports installing/updating/uninstalling of Overlays.
  * Supports accessing Overlays from various media types:
    * CVS
    * Subversion (SVN)
    * Git
    * Rsync
    * Darcs
* Allows for the loading of Extensions from one or more Overlays.
* Provides persistent storage of objects using DataMapper.
* Caches and mirrors objects stored in Overlays using DataMapper.
* Provides convenience methods for:
  * Formatting data:
    * Binary
    * HTTP
    * URIs
    * HTML
  * Generating random text.
  * Networking:
    * TCP
    * UDP
    * SMTP
    * POP
    * Imap
    * Telnet
    * HTTP
* Provides an IRB styled console with:
  * Tab-completion enabled.
  * Auto-indentation enabled.
  * Pretty-Print loaded.

== REQUIREMENTS:

* {libsqlite3}[http://sqlite.org/]
* {DataMapper}[http://datamapper.org/]:
  * dm-core >= 0.9.9
  * data_objects >= 0.9.9
  * do_sqlite3 >= 0.9.9
  * dm-types >= 0.9.9
  * dm-aggregates >= 0.9.9
  * dm-validations >= 0.9.9
  * dm-serializer >= 0.9.9
* {dm-prefined}[http://dm-predefined.rubyforge.org/] >= 0.1.0
* {parameters}[http://parameters.rubyforge.org/] >= 0.1.2
* {contextify}[http://contextify.rubyforge.org/] >= 0.1.0
* {reverse-require}[http://reverserequire.rubyforge.org/] >= 0.3.1
* {repertoire}[http://repertoire.rubyforge.org/] >= 0.1.2

== INSTALL:

  $ sudo gem install ronin

== SYNOPSIS:

* Generate an Overlay:

    $ ronin overlay path/to/overlay/name/

* Generate an Extension within an Overlay:

    $ ronin ext path/to/overlay/extension/

* Install an Overlay:

    $ ronin install svn://example.com/var/svn/overlay

* List installed Overlays:

    $ ronin ls

* Update all installed Overlays:

    $ ronin up

* Update a specific Overlay:

    $ ronin up overlay-name

* Uninstall an Overlay:

    $ ronin uninstall overlay-name

* Start the Ronin console:

    $ ronin

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

=== Ronin HTML

* http://ronin.rubyforge.org/html/
* http://github.com/postmodern/ronin-html

Ronin HTML is a Ruby library for Ronin that provides support for generating
complex HTML/JavaScript or crafting XSS/CSRF attacks.

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

Ronin - A Ruby platform designed for information security and data
exploration tasks.

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
