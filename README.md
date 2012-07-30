# Ronin

* [Website](http://ronin-ruby.github.com)
* [Source](https://github.com/ronin-ruby/ronin)
* [Issues](https://github.com/ronin-ruby/ronin/issues)
* [Documentation](http://ronin-ruby.github.com/docs/ronin/frames)
* [Mailing List](https://groups.google.com/group/ronin-ruby)
* [irc.freenode.net #ronin](http://ronin-ruby.github.com/irc/)

## Description

Ronin is a [Ruby](http://www.ruby-lang.org) platform for
vulnerability research and [exploit development](http://www.exploit-db.com).
Ronin allows for the rapid development and distribution of code,
[exploits](https://github.com/postmodern/postmodern/blob/master/scripts/exploits/http/oracle/dav_bypass.rb)
or [payloads](https://gist.github.com/1403961) via
[Repositories](https://github.com/postmodern/postmodern).

### Console

Ronin provides users with a powerful Ruby Console, pre-loaded with powerful
convenience methods. In the Console one can work with data and automate
complex tasks, with greater ease than the command-line.

    >> File.read('data').base64_decode

### Database

Ronin ships with a preconfigured Database, that one can interact with from Ruby,
without having to write any SQL.

    >> HostName.tld('eu').urls.with_query_param('id')

### Repositories

Ronin provides a Repository system, allowing users to organize and share
miscallaneous Data, Code, Exploits, Payloads, Scanners, etc.

    $ ronin install git://github.com/user/myexploits.git

### Libraries

Ronin provides libraries with additional functionality, such as
[Exploitation](https://github.com/ronin-ruby/ronin-exploits#readme)
and [Scanning](https://github.com/ronin-ruby/ronin-scanners#readme).

    $ gem install ronin-exploits

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
  [ronin-support](https://github.com/ronin-ruby/ronin-support#readme).
* Provides a customized Ruby Console using
  [Ripl](https://github.com/cldwalker/ripl#readme) with:
  * Syntax highlighting.
  * Tab completion.
  * Auto indentation.
  * Pretty Printing (`pp`).
  * `print_info`, `print_error`, `print_warning` and `print_debug`
    output helper methods with color-output.
  * Inline commands (`!nmap -v -sT victim.com`)
* Provides an extensible command-line interface.

## Synopsis

Start the Ronin console:

    $ ronin

Run a Ruby script in Ronin:

    $ ronin exec script.rb

View available commands:

    $ ronin help

View a man-page for a command:

    $ ronin help wordlist

Install a Repository:

    $ ronin install svn://example.com/path/to/repo

List installed Repositories:

    $ ronin repos

Update all installed Repositories:

    $ ronin update

Update a specific Repositories:

    $ ronin update repo-name

Uninstall a specific Repositories:

    $ ronin uninstall repo-name

List available Databases:

    $ ronin database

Add a new Database:

    $ ronin database --add team --uri mysql://user:pass@vpn.example.com/db

Remove a Database:

    $ ronin database --remove team

## Requirements

* [Ruby](http://www.ruby-lang.org/) >= 1.8.7
* [DataMapper](http://datamapper.org/):
  * [dm-sqlite-adapter](https://github.com/datamapper/dm-sqlite-adapter#readme)
    ~> 1.2
    * [libsqlite3](http://sqlite.org/)
  * [dm-core](https://github.com/datamapper/dm-core#readme)
    ~> 1.2
  * [dm-types](https://github.com/datamapper/dm-types#readme)
    ~> 1.2
  * [dm-migrations](https://github.com/datamapper/dm-migrations#readme)
    ~> 1.2
  * [dm-validations](https://github.com/datamapper/dm-validations#readme)
    ~> 1.2
  * [dm-aggregates](https://github.com/datamapper/dm-aggregates#readme)
     ~> 1.2
  * [dm-timestamps](https://github.com/datamapper/dm-timestamps#readme)
    ~> 1.2
* [dm-is-predefined](https://github.com/postmodern/dm-is-predefined#readme)
  ~> 0.4
* [uri-query_params](https://github.com/postmodern/uri-query_params#readme)
  ~> 0.6
* [open_namespace](https://github.com/postmodern/open_namespace#readme)
  ~> 0.4
* [data_paths](https://github.com/postmodern/data_paths#readme)
  ~> 0.3
* [object_loader](https://github.com/postmodern/object_loader#readme)
  ~> 1.0
* [parameters](https://github.com/postmodern/parameters#readme)
  ~> 0.4
* [pullr](https://github.com/postmodern/pullr#readme)
  ~> 0.1, >= 0.1.2
* [ripl](https://github.com/cldwalker/ripl#readme)
  ~> 0.3
* [ripl-multi_line](https://github.com/janlelis/ripl-multi_line#readme)
  ~> 0.2
* [ripl-auto_indent](https://github.com/janlelis/ripl-auto_indent#readme)
  ~> 0.1
* [ripl-short_errors](https://rubygems.org/gems/ripl-short_errors)
  ~> 0.1
* [ripl-color_result](https://github.com/janlelis/ripl-color_result#readme)
  ~> 0.3
* [ronin-support](https://github.com/ronin-ruby/ronin-support#readme)
  ~> 0.5

## Install

### Stable

    $ gem install ronin

### Edge

    $ git clone git://github.com/ronin-ruby/ronin.git
    $ cd ronin/
    $ bundle install
    $ ./bin/ronin

## License

Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)

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
