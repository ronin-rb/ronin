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
  * [ronin-fuzzing]
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

    $ ronin help console

Open the Ronin Ruby console:

    $ ronin console

## Requirements

* [Ruby] >= 3.0.0
* [open_namespace] ~> 0.4
* [ronin-support] ~> 1.0
* [ronin-core] ~> 0.1
* [ronin-repos] ~> 0.1
* [ronin-db] ~> 0.1
* [ronin-fuzzer] ~> 0.1
* [ronin-asm] ~> 0.3
* [ronin-sql] ~> 1.2
* [ronin-web] ~> 1.0
* [ronin-payloads] ~> 0.1
* [ronin-exploits] ~> 1.0

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

Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)

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
[open_namespace]: https://github.com/postmodern/open_namespace#readme

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-fuzzing]: https://github.com/ronin-rb/ronin-fuzzing#readme
[ronin-web]: https://github.com/ronin-rb/ronin-web#readme
[ronin-asm]: https://github.com/ronin-rb/ronin-asm#readme
[ronin-sql]: https://github.com/ronin-rb/ronin-sql#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-post_exploitation]: https://github.com/ronin-rb/ronin-post_exploitation#readme
[ronin-scanners]: https://github.com/ronin-rb/ronin-scanners#readme

[git]: https://git-scm.com/
