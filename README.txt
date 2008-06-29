= Ronin

* http://ronin.rubyforge.org/
* Postmodern Modulus III

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

Ronin was not designed as one monolithic library but instead as a collection
of libraries which can be individually installed. This allows users to pick
and choose what functionality they want in Ronin.

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
* Provides persistent storage using DataMapper.
* Provides convenience methods for:
  * Formatting data:
    * Binary
    * HTTP
    * URIs
    * HTML
  * Networking:
    * TCP
    * UDP
    * SMTP
    * POP
    * Imap
    * Telnet
    * HTTP
  * Web access (utilizing Mechanize and Hpricot).
* Provides an IRB styled console with:
  * Tab-completion enabled.
  * Auto-indentation enabled.
  * Pretty-Print loaded.

== SYNOPSIS:

* List installed Overlays:

    $ ronin ls

* Install an Overlay:

    $ ronin install svn://example.com/var/svn/overlay

* Update all installed Overlays:

    $ ronin up

* Update a specific Overlay:

    $ ronin up overlay-name

* Uninstall an Overlay:

    $ ronin uninstall overlay-name

* Start the Ronin console:

    $ ronin

== REQUIREMENTS:

* Hpricot
* Mechanize
* DataMapper:
  * dm-core
  * data_objects
  * do_sqlite3
  * dm-types
  * dm-serializer
  * dm-aggregates
  * dm-ar-finders
* R'epertoire
* reverserequire

== INSTALL:

  $ sudo gem install ronin

== LICENSE:

Ronin - A Ruby platform designed for information security and data
exploration tasks.

Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)

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
