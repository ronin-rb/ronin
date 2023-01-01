# ronin-cert-gen 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin cert-gen` [*options*]

## DESCRIPTION

Generates a new X509 certificate.

## OPTIONS

`--version` *NUM*
  The certificate version number Defaults to `2` if not given.

`--serial` *NUM*
  The certificate serial number Defaults to `0` if not given.

`--not-before` *TIME*
  When the certificate becomes valid. Defaults to the current time.

`--not-after` *TIME*
  When the certificate becomes no longer valid. Defaults to one year from now.

`-c`, `--common-name` *DOMAIN*
  The Common Name (CN) for the certificate.

`-A`, `--subject-alt-name` *HOST*\|*IP*
  Adds HOST or IP to `subjectAltName`.

`-O`, `--organization` *NAME*
  The Organization (O) for the certificate.

`-U`, `--organizational-unit` *NAME*
  The Organizational Unit (OU).

`-L`, `--locality` *NAME*
  The locality for the certificate.

`-S`, `--state *XX*
  The two-letter State (ST) code for the certificate.

`-C`, `--country` *XX*
  The two-letter Country (C) code for the certificate.

`-t`, `--key-type` rsa|ec`            The signing key type
    --generate-key PATH          Generates and saves a random key (Default: key.pem)
-k, --key-file FILE              Loads the signing key from the FILE
`-H`, `--signing-hash` `sha256`\|`sha1`\|`md5`
  The hash algorithm to use for signing. Defaults to `sha256` if not given.

`--ca-key` *FILE*
  The Certificate Authority (CA) key.

`--ca-cert` *FILE*
  The Certificate Authority (CA) certificate.

`--ca`
  Generates a CA certificate.

`-o`, `--output` *FILE*
  The output file to save the generated certificate to. Defaults to `cert.crt`
  if not given.

`-h`, `--help`
  Print help information.

## EXAMPLES

Generates self-signed certificate in `cert.crt` and a new private key in `key.pem`:

        ronin cert_gen -c test.com -O "Test Co" -U "Test Dept" \
                       -L "Test City" -S NY -C US

Generates a new self-signed certificate for `test.com` in `cert.crt` using the private key in
`private.key`:

        ronin cert_gen -c test.com -O "Test Co" -U "Test Dept" \
                       -L "Test City" -S NY -C US \
                       --key-file private.key

Generates a new self-signed certificate with a alternative name `www.test.com`:

        ronin cert_gen -c test.com -A www.test.com -O "Test Co" -U "Test Dept" \
                       -L "Test City" -S NY -C US

Generates a new CA certificate which can sign other certificates:

        ronin cert_gen --ca -c "Test CA" -O "Test Co" -U "Test Dept" \
                       -L "Test City" -S NY -C US

Generates a new sub-certificate using the CA certificate `ca.crt` and signing key `ca.key`:

        ronin cert_gen -c test.com -O "Test Co" -U "Test Dept" \
                       -L "Test City" -S NY -C US \
                       --ca-key ca.key --ca-cert ca.crt

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-cert-grab(1) ronin-cert-dump(1)
