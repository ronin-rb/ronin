# ronin-http 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin http` [*options*] [*URL* ...]

## DESCRIPTION

Send HTTP requests or spawn an interactive HTTP shell.

## ARGUMENTS

*URL*
  A URL to request.

## OPTIONS

`-v`, `--verbose`
  Enables verbose output.

`-f`, `--file` *FILE*
  Optional file to read values from.

`--method` *HTTP_METHOD*
  Send the HTTP request method.

`--get`
  Send a GET request.

`--head`
  Send a HEAD request.

`--patch`
  Send a PATCH request.

`--post`
  Send a POST request.

`--put`
  Send a PUT request.

`--copy`
  Send a COPY request.

`--delete`
  Send a DELETE request.

`--lock`
  Send a LOCK request.

`--options`
  Send a OPTIONS request.

`--mkcol`
  Send a MKCOL request.

`--move`
  Send a MOVE request.

`--propfind`
  Send a PROPFIND request.

`--proppatch`
  Send a PROPPATCH request.

`--trace`
  Send a TRACE request.

`--unlock`
  Send an UNLOCK request.

`--shell` *URL*
  Open an interactive HTTP shell.

`-P`, `--proxy` *URL*
  The proxy to use.

`-U`, `--user-agent-string` *STRING*
  The User-Agent string to use.

`-u`, `--user-agent` *chrome_linux*\|*chrome_macos*\|*chrome_windows*\|*chrome_iphone*\|*chrome_ipad*\|*chrome_android*\|*firefox_linux*\|*firefox_macos*\|*firefox_windows*\|*firefox_iphone*\|*firefox_ipad*\|*firefox_android*\|*safari_macos*\|*safari_iphone*\|*safari_ipad*\|*edge*
  The User-Agent to use.

`-H`, `--header` "*NAME*: *VALUE*"
  Adds a header to the request.

`-B`, `--body` *STRING*
  The request body.

`-F`, `--body-file` *FILE*
  Sends the file as the request body.

`-f`, `--form-data` *NAME*=*VALUE*
  Adds a value to the form data.

`-q`, `--query-param` *NAME*=*VALUE*
  Adds a query param to the URL.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

