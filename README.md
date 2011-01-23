# Ronin

* [Website](http://ronin-ruby.github.com)
* [Source](http://github.com/ronin-ruby/ronin)
* [Issues](http://github.com/ronin-ruby/ronin/issues)
* [Documentation](http://rubydoc.info/github/ronin-ruby/ronin/frames)
* [Mailing List](http://groups.google.com/group/ronin-ruby)
* irc.freenode.net #ronin

## Description

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

### Hack with Ruby

Ronin combines all of the flexibility of Ruby with countless convenience
methods and libraries, to provide a tailored Ruby environment for
Researchers and Hackers.

### Organize Your Data

Ronin comes with a fully designed Database accessible from Ruby using
[DataMapper](http://datamapper.org). With Ronin, storing or querying
IP addresses, Hosts, Ports, URLs, Passwords is as simple as a single line
of Ruby.

### Share Code

Ronin makes sharing code with the community, or just your friends, as easy
as uploading your Ruby files to any SubVersion, Mercurial or Git Repository.

## Features

* Supports installing/updating/uninstalling of Repositories.
  * Supports installing Repositories from various media types:
    * [Subversion (SVN)](http://subversion.tigris.org/)
    * [Mercurial (Hg)](http://mercurial.selenic.com/)
    * [Git](http://git-scm.com/)
    * Rsync
* Provides Object Database using [DataMapper](http://datamapper.org)
  with:
  * {Ronin::Author}
  * {Ronin::License}
  * {Ronin::Arch}
  * {Ronin::OS}
  * {Ronin::Software}
  * {Ronin::Vendor}
  * {Ronin::Address}
    * {Ronin::MACAddress}
    * {Ronin::IPAddress}
    * {Ronin::HostName}
  * {Ronin::Port}
    * {Ronin::TCPPort}
    * {Ronin::UDPPort}
  * {Ronin::Service}
  * {Ronin::OpenPort}
  * {Ronin::OSGuess}
  * {Ronin::UserName}
  * {Ronin::URL}
  * {Ronin::EmailAddress}
  * {Ronin::Credential}
  * {Ronin::ServiceCredential}
  * {Ronin::WebCredential}
  * {Ronin::Organization}
  * {Ronin::Campaign}
  * {Ronin::Target}
* Caches exploits, payloads, scanners, etc stored within Repositories
  into the Database.
* Convenience methods provided by
  [ronin-support](http://github.com/ronin-ruby/ronin-support#readme).
* Provides a customized Ruby Console with:
  * Tab-completion enabled.
  * Auto-indentation enabled.
  * Pretty-Print loaded.
  * `print_info`, `print_error`, `print_warning` and `print_debug`
    output helper methods with color-output.
* Provides an extensible command-line interface based on
  [Thor](http://github.com/wycats/thor#readme).

## Synopsis

Start the Ronin console:

    $ ronin

Run a Ruby script in Ronin:

    $ ronin exec script.rb

View available commands:

    $ ronin help

Install a Repository:

    $ ronin repos --install svn://example.com/path/to/repo

List installed Repositories:

    $ ronin repos

Update all installed Repositories:

    $ ronin repos --update

Update a specific Repositories:

    $ ronin repos --update repo-name

Uninstall an Repositories:

    $ ronin repos --uninstall repo-name

List available Databases:

    $ ronin database

Add a new Database:

    $ ronin database --add team --uri mysql://user:pass@vpn.example.com/db

Remove a Database:

    $ ronin database --remove team

## Requirements

* [Ruby](http://www.ruby-lang.org/) >= 1.8.7
* [ActiveSupport](http://rubygems.org/gems/activesupport) >= 3.0.0
* [DataMapper](http://datamapper.org/):
  * [dm-do-adapter](http://github.com/datamapper/dm-do-adapter) ~> 1.0.2
  * [dm-sqlite-adapter](http://github.com/datamapper/dm-sqlite-adapter)
    ~> 1.0.2
    * [libsqlite3](http://sqlite.org/)
  * [dm-core](http://github.com/datamapper/dm-core) ~> 1.0.2
  * [dm-types](http://github.com/datamapper/dm-types) ~> 1.0.2
  * [dm-migrations](http://github.com/datamapper/dm-migrations) ~> 1.0.2
  * [dm-validations](http://github.com/datamapper/dm-validations) ~> 1.0.2
  * [dm-aggregates](http://github.com/datamapper/dm-aggregates) ~> 1.0.2
  * [dm-timestamps](http://github.com/datamapper/dm-timestamps) ~> 1.0.2
  * [dm-tags](http://github.com/datamapper/dm-tags) ~> 1.0.2
* [dm-is-predefined](http://github.com/postmodern/dm-is-predefined/)
  ~> 0.3.0
* [env](http://github.com/postmodern/env) ~> 0.1.2
* [uri-query_params](http://github.com/postmodern/uri-query_params) ~> 0.4.0
* [open_namespace](http://github.com/postmodern/open_namespace) ~> 0.3.0
* [parameters](http://github.com/postmodern/parameters) ~> 0.2.2
* [data_paths](http://github.com/postmodern/data_paths) ~> 0.2.1
* [contextify](http://github.com/postmodern/contextify/) ~> 0.1.6
* [pullr](http://github.com/postmodern/pullr/) ~> 0.1.2
* [thor](http://github.com/wycats/thor/) ~> 0.14.2
* [ronin-support](http://github.com/ronin-ruby/ronin-support/) ~> 0.1.0

## Install

    $ sudo gem install ronin

## Additional Libraries

### Ronin ASM

[Ronin ASM](http://github.com/ronin-ruby/ronin-asm#readme) is a
Ruby library for Ronin that provides dynamic Assembly (ASM) generation of
programs or shellcode.

### Ronin Dorks

[Ronin Dorks](http://github.com/ronin-ruby/ronin-dorks#readme) is a
Ruby library for Ronin that provides support for various Google (tm) Dorks
functionality.

### Ronin Exploits

[Ronin Exploits](http://github.com/ronin-ruby/ronin-exploits#readme) is a
Ruby library for Ronin that provides exploitation and payload crafting
functionality.

### Ronin Gen

[Ronin Gen](http://github.com/ronin-ruby/ronin-gen#readme) is a Ruby library
for Ronin that provides various generators.

### Ronin SQL

[Ronin SQL](http://github.com/ronin-ruby/ronin-sql#readme) is a Ruby library
for Ronin that provides support for SQL related security tasks, such as
scanning for and exploiting SQL injections.

### Ronin PHP

[Ronin PHP](http://github.com/ronin-ruby/ronin-php#readme) is a Ruby library
for Ronin that provides support for PHP related security tasks, such as
finding and exploiting Local File Inclusion (LFI) and
Remote File Inclusion (RFI).

### Ronin Web

[Ronin Web](http://github.com/ronin-ruby/ronin-web#readme) is a Ruby library
for Ronin that provides support for web scraping and spidering
functionality.

## License

Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of Ronin.

Ronin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
