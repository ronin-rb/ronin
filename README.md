# ronin

[![CI](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin.svg)](https://codeclimate.com/github/ronin-rb/ronin)

* [Website](https://ronin-rb.dev)
* [Source](https://github.com/ronin-rb/ronin)
* [Issues](https://github.com/ronin-rb/ronin/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb)

## Description

[Ronin][ronin-rb] is a [Ruby] toolkit for security research and development.

### Who is Ronin for?

* CTF Players
* Bug hunters
* Security Researchers
* Security Engineers
* Developers

### What does Ronin provide?

* A suite of useful commands.
* A customized Ruby console.
* A collection of additional high-quality Ruby libraries and commands:
  * [ronin-support]
  * [ronin-repos]
  * [ronin-db]
  * [ronin-web]
  * [ronin-asm]
  * [ronin-sql]
  * [ronin-payloads]
  * [ronin-exploits]
  * [ronin-post_exploitation]
  * [ronin-scanners]

### What can you do with Ronin?

* Rapidly prototype Ruby scripts using [ronin-support].
* Effectively work with data in the `ronin console`.
* Install 3rd-party [git] repositories of code/data using [ronin-repos].
* Import and query data using [ronin-db].
* Write/Run Exploits using [ronin-exploits].
* Write/Run custom Scanners using [ronin-scanners].

## Synopsis

List ronin commands:

    $ ronin help

View a man-page for a command:

    $ ronin help wordlist

Open the Ronin Ruby console:

    $ ronin console

## Requirements

* [Ruby] >= 2.6.0
* [DataMapper]:
  * [dm-sqlite-adapter] ~> 1.2
    * [libsqlite3]
  * [dm-core] ~> 1.2
  * [dm-types] ~> 1.2
  * [dm-migrations] ~> 1.2
  * [dm-validations] ~> 1.2
  * [dm-aggregates] ~> 1.2
  * [dm-timestamps] ~> 1.2
  * [dm-serializer] ~> 1.2
* [uri-query_params] ~> 0.6
* [open_namespace] ~> 0.4
* [data_paths] ~> 0.3
* [object_loader] ~> 1.0
* [parameters] ~> 0.4
* [pullr] ~> 0.1, >= 0.1.2
* [ripl] ~> 0.3
* [ripl-multi_line] ~> 0.2
* [ripl-auto_indent] ~> 0.1
* [ripl-short_errors] ~> 0.1
* [ripl-color_result] ~> 0.3
* [ripl-shell_commands] ~> 0.1
* [ronin-support] ~> 0.6
* [ronin-db] ~> 0.1
* [ronin-repos] ~> 0.1

## Install

    $ gem install ronin

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

Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of ronin.

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

[ronin-rb]: https://ronin-rb.dev/
[Ruby]: https://www.ruby-lang.org

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-web]: https://github.com/ronin-rb/ronin-web#readme
[ronin-asm]: https://github.com/ronin-rb/ronin-asm#readme
[ronin-sql]: https://github.com/ronin-rb/ronin-sql#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-post_exploitation]: https://github.com/ronin-rb/ronin-post_exploitation#readme
[ronin-scanners]: https://github.com/ronin-rb/ronin-scanners#readme

[git]: https://git-scm.com/

[DataMapper]: http://datamapper.org
[dm-sqlite-adapter]: https://github.com/datamapper/dm-sqlite-adapter#readme
[libsqlite3]: https://sqlite.org/
[dm-core]: https://github.com/datamapper/dm-core#readme
[dm-types]: https://github.com/datamapper/dm-types#readme
[dm-migrations]: https://github.com/datamapper/dm-migrations#readme
[dm-validations]: https://github.com/datamapper/dm-validations#readme
[dm-aggregates]: https://github.com/datamapper/dm-aggregates#readme
[dm-timestamps]: https://github.com/datamapper/dm-timestamps#readme
[dm-serializer]: https://github.com/datamapper/dm-serializer#readme
[uri-query_params]: https://github.com/postmodern/uri-query_params#readme
[open_namespace]: https://github.com/postmodern/open_namespace#readme
[data_paths]: https://github.com/postmodern/data_paths#readme
[object_loader]: https://github.com/postmodern/object_loader#readme
[parameters]: https://github.com/postmodern/parameters#readme
[pullr]: https://github.com/postmodern/pullr#readme
[ripl]: https://github.com/cldwalker/ripl#readme
[ripl-multi_line]: https://github.com/janlelis/ripl-multi_line#readme
[ripl-auto_indent]: https://github.com/janlelis/ripl-auto_indent#readme
[ripl-short_errors]: https://rubygems.org/gems/ripl-short_errors
[ripl-color_result]: https://github.com/janlelis/ripl-color_result#readme
[ripl-shell_commands]: https://github.com/postmodern/ripl-shell_commands#readme
