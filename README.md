# Ronin

* [Website](http://ronin-ruby.github.com)
* [Source](http://github.com/ronin-ruby/ronin)
* [Issues](http://github.com/ronin-ruby/ronin/issues)
* [Documentation](http://rubydoc.info/gems/ronin/frames)
* [Mailing List](http://groups.google.com/group/ronin-ruby)
* irc.freenode.net #ronin

## Description

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

### Hack with Ruby

Ronin combines the flexibility of Ruby with countless convenience methods
and libraries, to make Ruby usable for Offensive Security or Research work.

### Organize Your Data

Ronin comes with a Database designed for Security data and accessible from
Ruby using [DataMapper](http://datamapper.org). With Ronin, storing or
querying IP addresses, Hosts, Ports, URLs, Passwords is as simple as a
single line of Ruby.

### Share Code

Ronin allows sharing code with the community, or just your friends, via
Ronin Repositories. Ronin Repositories are like lazier versions of
[RubyGems](http://rubygems.org/), that can be hosted with SubVersion,
Mercurial or Git.

## Features

* Supports installing/updating/uninstalling of Repositories.
  * Supports installing Repositories from various media types:
    * [Subversion (SVN)](http://subversion.tigris.org/)
    * [Mercurial (Hg)](http://mercurial.selenic.com/)
    * [Git](http://git-scm.com/)
    * Rsync
* Provides a Database using [DataMapper](http://datamapper.org) with:
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
  * Syntax highlighting.
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
* [DataMapper](http://datamapper.org/):
  * [dm-do-adapter](http://github.com/datamapper/dm-do-adapter#readme)
    ~> 1.1.0
  * [dm-sqlite-adapter](http://github.com/datamapper/dm-sqlite-adapter#readme)
    ~> 1.1.0
    * [libsqlite3](http://sqlite.org/)
  * [dm-core](http://github.com/datamapper/dm-core#readme)
    ~> 1.1.0
  * [dm-types](http://github.com/datamapper/dm-types#readme)
    ~> 1.1.0
  * [dm-migrations](http://github.com/datamapper/dm-migrations#readme)
    ~> 1.1.0
  * [dm-validations](http://github.com/datamapper/dm-validations#readme)
    ~> 1.1.0
  * [dm-aggregates](http://github.com/datamapper/dm-aggregates#readme)
     ~> 1.1.0
  * [dm-timestamps](http://github.com/datamapper/dm-timestamps#readme)
    ~> 1.1.0
* [dm-is-predefined](http://github.com/postmodern/dm-is-predefined#readme)
  ~> 0.3, >= 0.3.1
* [uri-query_params](http://github.com/postmodern/uri-query_params#readme)
  ~> 0.5, >= 0.5.2
* [open_namespace](http://github.com/postmodern/open_namespace#readme)
  ~> 0.3
* [parameters](http://github.com/postmodern/parameters#readme)
  ~> 0.2, >= 0.2.3
* [data_paths](http://github.com/postmodern/data_paths#readme)
  ~> 0.2, >= 0.2.1
* [contextify](http://github.com/postmodern/contextify#readme)
  ~> 0.2
* [env](http://github.com/postmodern/env#readme)
  ~> 0.1, >= 0.1.2
* [pullr](http://github.com/postmodern/pullr#readme)
  ~> 0.1, >= 0.1.2
* [hexdump](http://github.com/postmodern/hexdump#readme)
  ~> 0.1
* [thor](http://github.com/wycats/thor#readme)
  ~> 0.14.3
* [ronin-support](http://github.com/ronin-ruby/ronin-support#readme)
  ~> 0.1

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
