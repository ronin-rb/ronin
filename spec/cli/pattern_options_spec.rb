require 'spec_helper'
require 'ronin/cli/pattern_options'
require 'ronin/cli/command'

describe Ronin::CLI::PatternOptions do
  module TestPatternOptions
    class TestCommand < Ronin::CLI::Command
      include Ronin::CLI::PatternOptions
    end
  end

  let(:command_class) { TestPatternOptions::TestCommand }
  subject { command_class.new }

  describe ".included" do
    subject { command_class }

    #
    # Numeric pattern options
    #
    it "must define a '-N,--number' option" do
      expect(subject.options[:number]).to_not be(nil)
      expect(subject.options[:number].short).to eq('-N')
      expect(subject.options[:number].value).to be(nil)
      expect(subject.options[:number].desc).to eq('Searches for all numbers')
    end

    it "must define a '-X,--hex-number' option" do
      expect(subject.options[:hex_number]).to_not be(nil)
      expect(subject.options[:hex_number].short).to eq('-X')
      expect(subject.options[:hex_number].value).to be(nil)
      expect(subject.options[:hex_number].desc).to eq('Searches for all hexadecimal numbers')
    end

    it "must define a '-V,--version-number' option" do
      expect(subject.options[:version_number]).to_not be(nil)
      expect(subject.options[:version_number].short).to eq('-V')
      expect(subject.options[:version_number].value).to be(nil)
      expect(subject.options[:version_number].desc).to eq('Searches for all version numbers')
    end

    #
    # Language pattern options
    #
    it "must define a '-w,--word' option" do
      expect(subject.options[:word]).to_not be(nil)
      expect(subject.options[:word].short).to eq('-w')
      expect(subject.options[:word].value).to be(nil)
      expect(subject.options[:word].desc).to eq('Searches for all words')
    end

    #
    # Network pattern options
    #
    it "must define a '--mac-addr' option" do
      expect(subject.options[:mac_addr]).to_not be(nil)
      expect(subject.options[:mac_addr].short).to be(nil)
      expect(subject.options[:mac_addr].value).to be(nil)
      expect(subject.options[:mac_addr].desc).to eq('Searches for all MAC addresses')
    end

    it "must define a '-4,--ipv4-addr' option" do
      expect(subject.options[:ipv4_addr]).to_not be(nil)
      expect(subject.options[:ipv4_addr].short).to eq('-4')
      expect(subject.options[:ipv4_addr].value).to be(nil)
      expect(subject.options[:ipv4_addr].desc).to eq('Searches for all IPv4 addresses')
    end

    it "must define a '-6,--ipv6-addr' option" do
      expect(subject.options[:ipv6_addr]).to_not be(nil)
      expect(subject.options[:ipv6_addr].short).to eq('-6')
      expect(subject.options[:ipv6_addr].value).to be(nil)
      expect(subject.options[:ipv6_addr].desc).to eq('Searches for all IPv6 addresses')
    end

    it "must define a '-I,--ip' option" do
      expect(subject.options[:ip]).to_not be(nil)
      expect(subject.options[:ip].short).to eq('-I')
      expect(subject.options[:ip].value).to be(nil)
      expect(subject.options[:ip].desc).to eq('Searches for all IP addresses')
    end

    it "must define a '-H,--host' option" do
      expect(subject.options[:host]).to_not be(nil)
      expect(subject.options[:host].short).to eq('-H')
      expect(subject.options[:host].value).to be(nil)
      expect(subject.options[:host].desc).to eq('Searches for all host names')
    end

    it "must define a '-D,--domain' option" do
      expect(subject.options[:domain]).to_not be(nil)
      expect(subject.options[:domain].short).to eq('-D')
      expect(subject.options[:domain].value).to be(nil)
      expect(subject.options[:domain].desc).to eq('Searches for all domain names')
    end

    it "must define a '--uri' option" do
      expect(subject.options[:uri]).to_not be(nil)
      expect(subject.options[:uri].short).to be(nil)
      expect(subject.options[:uri].value).to be(nil)
      expect(subject.options[:uri].desc).to eq('Searches for all URIs')
    end

    it "must define a '-U,--url' option" do
      expect(subject.options[:url]).to_not be(nil)
      expect(subject.options[:url].short).to eq('-U')
      expect(subject.options[:url].value).to be(nil)
      expect(subject.options[:url].desc).to eq('Searches for all URLs')
    end

    #
    # PII pattern options
    #
    it "must define a '--user-name' option" do
      expect(subject.options[:user_name]).to_not be(nil)
      expect(subject.options[:user_name].short).to be(nil)
      expect(subject.options[:user_name].value).to be(nil)
      expect(subject.options[:user_name].desc).to eq('Searches for all user names')
    end

    it "must define a '-E,--email-addr' option" do
      expect(subject.options[:email_addr]).to_not be(nil)
      expect(subject.options[:email_addr].short).to eq('-E')
      expect(subject.options[:email_addr].value).to be(nil)
      expect(subject.options[:email_addr].desc).to eq('Searches for all email addresses')
    end

    it "must define a '--obfuscated-email-addr' option" do
      expect(subject.options[:obfuscated_email_addr]).to_not be(nil)
      expect(subject.options[:obfuscated_email_addr].short).to be(nil)
      expect(subject.options[:obfuscated_email_addr].value).to be(nil)
      expect(subject.options[:obfuscated_email_addr].desc).to eq('Searches for all obfuscated email addresses')
    end

    it "must define a '--phone-number' option" do
      expect(subject.options[:phone_number]).to_not be(nil)
      expect(subject.options[:phone_number].short).to be(nil)
      expect(subject.options[:phone_number].value).to be(nil)
      expect(subject.options[:phone_number].desc).to eq('Searches for all phone numbers')
    end

    it "must define a '--ssn' option" do
      expect(subject.options[:ssn]).to_not be(nil)
      expect(subject.options[:ssn].short).to be(nil)
      expect(subject.options[:ssn].value).to be(nil)
      expect(subject.options[:ssn].desc).to eq('Searches for all Social Security Numbers (SSNs)')
    end

    it "must define a '--amex-cc' option" do
      expect(subject.options[:amex_cc]).to_not be(nil)
      expect(subject.options[:amex_cc].short).to be(nil)
      expect(subject.options[:amex_cc].value).to be(nil)
      expect(subject.options[:amex_cc].desc).to eq('Searches for all AMEX Credit Card numbers')
    end

    it "must define a '--discover-cc' option" do
      expect(subject.options[:discover_cc]).to_not be(nil)
      expect(subject.options[:discover_cc].short).to be(nil)
      expect(subject.options[:discover_cc].value).to be(nil)
      expect(subject.options[:discover_cc].desc).to eq('Searches for all Discover Card numbers')
    end

    it "must define a '--mastercard-cc' option" do
      expect(subject.options[:mastercard_cc]).to_not be(nil)
      expect(subject.options[:mastercard_cc].short).to be(nil)
      expect(subject.options[:mastercard_cc].value).to be(nil)
      expect(subject.options[:mastercard_cc].desc).to eq('Searches for all MasterCard numbers')
    end

    it "must define a '--visa-cc' option" do
      expect(subject.options[:visa_cc]).to_not be(nil)
      expect(subject.options[:visa_cc].short).to be(nil)
      expect(subject.options[:visa_cc].value).to be(nil)
      expect(subject.options[:visa_cc].desc).to eq('Searches for all VISA Credit Card numbers')
    end

    it "must define a '--visa-mastercard-cc' option" do
      expect(subject.options[:visa_mastercard_cc]).to_not be(nil)
      expect(subject.options[:visa_mastercard_cc].short).to be(nil)
      expect(subject.options[:visa_mastercard_cc].value).to be(nil)
      expect(subject.options[:visa_mastercard_cc].desc).to eq('Searches for all VISA MasterCard numbers')
    end

    it "must define a '--cc' option" do
      expect(subject.options[:cc]).to_not be(nil)
      expect(subject.options[:cc].short).to be(nil)
      expect(subject.options[:cc].value).to be(nil)
      expect(subject.options[:cc].desc).to eq('Searches for all Credit Card numbers')
    end

    #
    # File System pattern options
    #
    it "must define a '--file-name' option" do
      expect(subject.options[:file_name]).to_not be(nil)
      expect(subject.options[:file_name].short).to be(nil)
      expect(subject.options[:file_name].value).to be(nil)
      expect(subject.options[:file_name].desc).to eq('Searches for all file names')
    end

    it "must define a '--dir-name' option" do
      expect(subject.options[:dir_name]).to_not be(nil)
      expect(subject.options[:dir_name].short).to be(nil)
      expect(subject.options[:dir_name].value).to be(nil)
      expect(subject.options[:dir_name].desc).to eq('Searches for all directory names')
    end

    it "must define a '--relative-unix-path' option" do
      expect(subject.options[:relative_unix_path]).to_not be(nil)
      expect(subject.options[:relative_unix_path].short).to be(nil)
      expect(subject.options[:relative_unix_path].value).to be(nil)
      expect(subject.options[:relative_unix_path].desc).to eq('Searches for all relative UNIX paths')
    end

    it "must define a '--absolute-unix-path' option" do
      expect(subject.options[:absolute_unix_path]).to_not be(nil)
      expect(subject.options[:absolute_unix_path].short).to be(nil)
      expect(subject.options[:absolute_unix_path].value).to be(nil)
      expect(subject.options[:absolute_unix_path].desc).to eq('Searches for all absolute UNIX paths')
    end

    it "must define a '--unix-path' option" do
      expect(subject.options[:unix_path]).to_not be(nil)
      expect(subject.options[:unix_path].short).to be(nil)
      expect(subject.options[:unix_path].value).to be(nil)
      expect(subject.options[:unix_path].desc).to eq('Searches for all UNIX paths')
    end

    it "must define a '--relative-windows-path' option" do
      expect(subject.options[:relative_windows_path]).to_not be(nil)
      expect(subject.options[:relative_windows_path].short).to be(nil)
      expect(subject.options[:relative_windows_path].value).to be(nil)
      expect(subject.options[:relative_windows_path].desc).to eq('Searches for all relative Windows paths')
    end

    it "must define a '--absolute-windows-path' option" do
      expect(subject.options[:absolute_windows_path]).to_not be(nil)
      expect(subject.options[:absolute_windows_path].short).to be(nil)
      expect(subject.options[:absolute_windows_path].value).to be(nil)
      expect(subject.options[:absolute_windows_path].desc).to eq('Searches for all absolute Windows paths')
    end

    it "must define a '--windows-path' option" do
      expect(subject.options[:windows_path]).to_not be(nil)
      expect(subject.options[:windows_path].short).to be(nil)
      expect(subject.options[:windows_path].value).to be(nil)
      expect(subject.options[:windows_path].desc).to eq('Searches for all Windows paths')
    end

    it "must define a '--relative-path' option" do
      expect(subject.options[:relative_path]).to_not be(nil)
      expect(subject.options[:relative_path].short).to be(nil)
      expect(subject.options[:relative_path].value).to be(nil)
      expect(subject.options[:relative_path].desc).to eq('Searches for all relative paths')
    end

    it "must define a '--absolute-path' option" do
      expect(subject.options[:absolute_path]).to_not be(nil)
      expect(subject.options[:absolute_path].short).to be(nil)
      expect(subject.options[:absolute_path].value).to be(nil)
      expect(subject.options[:absolute_path].desc).to eq('Searches for all absolute paths')
    end

    it "must define a '--path' option" do
      expect(subject.options[:path]).to_not be(nil)
      expect(subject.options[:path].short).to eq('-P')
      expect(subject.options[:path].value).to be(nil)
      expect(subject.options[:path].desc).to eq('Searches for all paths')
    end

    #
    # Source Code pattern options
    #
    it "must define a '--identifier' option" do
      expect(subject.options[:identifier]).to_not be(nil)
      expect(subject.options[:identifier].short).to be(nil)
      expect(subject.options[:identifier].value).to be(nil)
      expect(subject.options[:identifier].desc).to eq('Searches for all identifier names')
    end

    it "must define a '--variable-name' option" do
      expect(subject.options[:variable_name]).to_not be(nil)
      expect(subject.options[:variable_name].short).to be(nil)
      expect(subject.options[:variable_name].value).to be(nil)
      expect(subject.options[:variable_name].desc).to eq('Searches for all variable names')
    end

    it "must define a '--variable-assignment' option" do
      expect(subject.options[:variable_assignment]).to_not be(nil)
      expect(subject.options[:variable_assignment].short).to be(nil)
      expect(subject.options[:variable_assignment].value).to be(nil)
      expect(subject.options[:variable_assignment].desc).to eq('Searches for all variable assignments')
    end

    it "must define a '--function-name' option" do
      expect(subject.options[:function_name]).to_not be(nil)
      expect(subject.options[:function_name].short).to be(nil)
      expect(subject.options[:function_name].value).to be(nil)
      expect(subject.options[:function_name].desc).to eq('Searches for all function names')
    end

    it "must define a '--single-quoted-string' option" do
      expect(subject.options[:single_quoted_string]).to_not be(nil)
      expect(subject.options[:single_quoted_string].short).to be(nil)
      expect(subject.options[:single_quoted_string].value).to be(nil)
      expect(subject.options[:single_quoted_string].desc).to eq('Searches for all single-quoted strings')
    end

    it "must define a '--double-quoted-string' option" do
      expect(subject.options[:double_quoted_string]).to_not be(nil)
      expect(subject.options[:double_quoted_string].short).to be(nil)
      expect(subject.options[:double_quoted_string].value).to be(nil)
      expect(subject.options[:double_quoted_string].desc).to eq('Searches for all double-quoted strings')
    end

    it "must define a '--string' option" do
      expect(subject.options[:string]).to_not be(nil)
      expect(subject.options[:string].short).to eq('-S')
      expect(subject.options[:string].value).to be(nil)
      expect(subject.options[:string].desc).to eq('Searches for all quoted strings')
    end

    it "must define a '--base64 ' option" do
      expect(subject.options[:base64]).to_not be(nil)
      expect(subject.options[:base64].short).to eq('-B')
      expect(subject.options[:base64].value).to be(nil)
      expect(subject.options[:base64].desc).to eq('Searches for all Base64 strings')
    end

    it "must define a '--c-comment' option" do
      expect(subject.options[:c_comment]).to_not be(nil)
      expect(subject.options[:c_comment].short).to be(nil)
      expect(subject.options[:c_comment].value).to be(nil)
      expect(subject.options[:c_comment].desc).to eq('Searches for all C comments')
    end

    it "must define a '--cpp-comment' option" do
      expect(subject.options[:cpp_comment]).to_not be(nil)
      expect(subject.options[:cpp_comment].short).to be(nil)
      expect(subject.options[:cpp_comment].value).to be(nil)
      expect(subject.options[:cpp_comment].desc).to eq('Searches for all C++ comments')
    end

    it "must define a '--java-comment' option" do
      expect(subject.options[:java_comment]).to_not be(nil)
      expect(subject.options[:java_comment].short).to be(nil)
      expect(subject.options[:java_comment].value).to be(nil)
      expect(subject.options[:java_comment].desc).to eq('Searches for all Java comments')
    end

    it "must define a '--javascript-comment' option" do
      expect(subject.options[:javascript_comment]).to_not be(nil)
      expect(subject.options[:javascript_comment].short).to be(nil)
      expect(subject.options[:javascript_comment].value).to be(nil)
      expect(subject.options[:javascript_comment].desc).to eq('Searches for all JavaScript comments')
    end

    it "must define a '--shell-comment' option" do
      expect(subject.options[:shell_comment]).to_not be(nil)
      expect(subject.options[:shell_comment].short).to be(nil)
      expect(subject.options[:shell_comment].value).to be(nil)
      expect(subject.options[:shell_comment].desc).to eq('Searches for all Shell comments')
    end

    it "must define a '--ruby-comment' option" do
      expect(subject.options[:ruby_comment]).to_not be(nil)
      expect(subject.options[:ruby_comment].short).to be(nil)
      expect(subject.options[:ruby_comment].value).to be(nil)
      expect(subject.options[:ruby_comment].desc).to eq('Searches for all Ruby comments')
    end

    it "must define a '--python-comment' option" do
      expect(subject.options[:python_comment]).to_not be(nil)
      expect(subject.options[:python_comment].short).to be(nil)
      expect(subject.options[:python_comment].value).to be(nil)
      expect(subject.options[:python_comment].desc).to eq('Searches for all Python comments')
    end

    it "must define a '--comment' option" do
      expect(subject.options[:comment]).to_not be(nil)
      expect(subject.options[:comment].short).to be(nil)
      expect(subject.options[:comment].value).to be(nil)
      expect(subject.options[:comment].desc).to eq('Searches for all comments')
    end

    #
    # Cryptographic pattern options
    #
    it "must define a '--md5' option" do
      expect(subject.options[:md5]).to_not be(nil)
      expect(subject.options[:md5].short).to be(nil)
      expect(subject.options[:md5].value).to be(nil)
      expect(subject.options[:md5].desc).to eq('Searches for all MD5 hashes')
    end

    it "must define a '--sha1' option" do
      expect(subject.options[:sha1]).to_not be(nil)
      expect(subject.options[:sha1].short).to be(nil)
      expect(subject.options[:sha1].value).to be(nil)
      expect(subject.options[:sha1].desc).to eq('Searches for all SHA1 hashes')
    end

    it "must define a '--sha256' option" do
      expect(subject.options[:sha256]).to_not be(nil)
      expect(subject.options[:sha256].short).to be(nil)
      expect(subject.options[:sha256].value).to be(nil)
      expect(subject.options[:sha256].desc).to eq('Searches for all SHA256 hashes')
    end

    it "must define a '--sha512' option" do
      expect(subject.options[:sha512]).to_not be(nil)
      expect(subject.options[:sha512].short).to be(nil)
      expect(subject.options[:sha512].value).to be(nil)
      expect(subject.options[:sha512].desc).to eq('Searches for all SHA512 hashes')
    end

    it "must define a '--hash' option" do
      expect(subject.options[:hash]).to_not be(nil)
      expect(subject.options[:hash].short).to be(nil)
      expect(subject.options[:hash].value).to be(nil)
      expect(subject.options[:hash].desc).to eq('Searches for all hashes')
    end

    it "must define a '--ssh-public-key' option" do
      expect(subject.options[:ssh_public_key]).to_not be(nil)
      expect(subject.options[:ssh_public_key].short).to be(nil)
      expect(subject.options[:ssh_public_key].value).to be(nil)
      expect(subject.options[:ssh_public_key].desc).to eq('Searches for all SSH public key data')
    end

    it "must define a '--public-key' option" do
      expect(subject.options[:public_key]).to_not be(nil)
      expect(subject.options[:public_key].short).to be(nil)
      expect(subject.options[:public_key].value).to be(nil)
      expect(subject.options[:public_key].desc).to eq('Searches for all public key data')
    end

    #
    # Credentials pattern options
    #
    it "must define a '--ssh-private-key' option" do
      expect(subject.options[:ssh_private_key]).to_not be(nil)
      expect(subject.options[:ssh_private_key].short).to be(nil)
      expect(subject.options[:ssh_private_key].value).to be(nil)
      expect(subject.options[:ssh_private_key].desc).to eq('Searches for all SSH private key data')
    end

    it "must define a '--dsa-private-key' option" do
      expect(subject.options[:dsa_private_key]).to_not be(nil)
      expect(subject.options[:dsa_private_key].short).to be(nil)
      expect(subject.options[:dsa_private_key].value).to be(nil)
      expect(subject.options[:dsa_private_key].desc).to eq('Searches for all DSA private key data')
    end

    it "must define a '--ec-private-key' option" do
      expect(subject.options[:ec_private_key]).to_not be(nil)
      expect(subject.options[:ec_private_key].short).to be(nil)
      expect(subject.options[:ec_private_key].value).to be(nil)
      expect(subject.options[:ec_private_key].desc).to eq('Searches for all EC private key data')
    end

    it "must define a '--rsa-private-key' option" do
      expect(subject.options[:rsa_private_key]).to_not be(nil)
      expect(subject.options[:rsa_private_key].short).to be(nil)
      expect(subject.options[:rsa_private_key].value).to be(nil)
      expect(subject.options[:rsa_private_key].desc).to eq('Searches for all RSA private key data')
    end

    it "must define a '--private-key' option" do
      expect(subject.options[:private_key]).to_not be(nil)
      expect(subject.options[:private_key].short).to eq('-K')
      expect(subject.options[:private_key].value).to be(nil)
      expect(subject.options[:private_key].desc).to eq('Searches for all private key data')
    end

    it "must define a '--aws-access-key-id' option" do
      expect(subject.options[:aws_access_key_id]).to_not be(nil)
      expect(subject.options[:aws_access_key_id].short).to be(nil)
      expect(subject.options[:aws_access_key_id].value).to be(nil)
      expect(subject.options[:aws_access_key_id].desc).to eq('Searches for all AWS access key IDs')
    end

    it "must define a '--aws-secret-access-key' option" do
      expect(subject.options[:aws_secret_access_key]).to_not be(nil)
      expect(subject.options[:aws_secret_access_key].short).to be(nil)
      expect(subject.options[:aws_secret_access_key].value).to be(nil)
      expect(subject.options[:aws_secret_access_key].desc).to eq('Searches for all AWS secret access keys')
    end

    it "must define a '--api-key' option" do
      expect(subject.options[:api_key]).to_not be(nil)
      expect(subject.options[:api_key].short).to eq('-A')
      expect(subject.options[:api_key].value).to be(nil)
      expect(subject.options[:api_key].desc).to eq('Searches for all API keys')
    end

    #
    # General options
    #
    it "must define a '-e,--regexp' option" do
      expect(subject.options[:regexp]).to_not be(nil)
      expect(subject.options[:regexp].short).to eq('-e')
      expect(subject.options[:regexp].value.type).to eq(Regexp)
      expect(subject.options[:regexp].desc).to eq('Custom regular expression to search for')
    end
  end

  describe "#option_parser" do
    shared_examples_for "pattern option" do |flag,constant|
      describe "when given '#{flag}'" do
        let(:flag) { flag }

        before { subject.option_parser.parse([flag]) }

        it "must set #pattern to Ronin::Support::Text::Patterns::#{constant}" do
          expect(subject.pattern).to be(
            Ronin::Support::Text::Patterns.const_get(constant)
          )
        end
      end
    end

    #
    # Numeric pattern options
    #
    include_context "pattern option", '-N', :NUMBER
    include_context "pattern option", '--number', :NUMBER
    include_context "pattern option", '-X', :HEX_NUMBER
    include_context "pattern option", '--hex-number', :HEX_NUMBER
    include_context "pattern option", '--version-number', :VERSION_NUMBER

    #
    # Language pattern options
    #
    include_context "pattern option", '-w', :WORD
    include_context "pattern option", '--word', :WORD

    #
    # Network pattern options
    #
    include_context "pattern option", '--mac-addr', :MAC_ADDR
    include_context "pattern option", '-4', :IPV4_ADDR
    include_context "pattern option", '--ipv4-addr', :IPV4_ADDR
    include_context "pattern option", '-6', :IPV6_ADDR
    include_context "pattern option", '--ipv6-addr', :IPV6_ADDR
    include_context "pattern option", '-I', :IP
    include_context "pattern option", '--ip', :IP
    include_context "pattern option", '-H', :HOST_NAME
    include_context "pattern option", '--host', :HOST_NAME
    include_context "pattern option", '-D', :DOMAIN
    include_context "pattern option", '--domain', :DOMAIN
    include_context "pattern option", '--URI', :URI
    include_context "pattern option", '-U', :URL
    include_context "pattern option", '--URL', :URL

    #
    # PII pattern options
    #
    include_context "pattern option", '--user-name', :USER_NAME
    include_context "pattern option", '-E', :EMAIL_ADDR
    include_context "pattern option", '--email-addr', :EMAIL_ADDRESS
    include_context "pattern option", '--obfuscated-email-addr', :OBFUSCATED_EMAIL_ADDRESS
    include_context "pattern option", '--phone-number', :PHONE_NUMBER
    include_context "pattern option", '--ssn', :SSN
    include_context "pattern option", '--amex-cc', :AMEX_CC
    include_context "pattern option", '--discover-cc', :DISCOVER_CC
    include_context "pattern option", '--mastercard-cc', :MASTERCARD_CC
    include_context "pattern option", '--visa-cc', :VISA_CC
    include_context "pattern option", '--visa-mastercard-cc', :VISA_MASTERCARD_CC
    include_context "pattern option", '--cc', :CC

    #
    # File System pattern options
    #
    include_context "pattern option", '--file-name', :FILE_NAME
    include_context "pattern option", '--dir-name', :DIR_NAME
    include_context "pattern option", '--relative-unix-path', :RELATIVE_UNIX_PATH
    include_context "pattern option", '--absolute-unix-path', :ABSOLUTE_UNIX_PATH
    include_context "pattern option", '--unix-path', :UNIX_PATH
    include_context "pattern option", '--relative-windows-path', :RELATIVE_WINDOWS_PATH
    include_context "pattern option", '--absolute-windows-path', :ABSOLUTE_WINDOWS_PATH
    include_context "pattern option", '--windows-path', :WINDOWS_PATH
    include_context "pattern option", '--relative-path', :RELATIVE_PATH
    include_context "pattern option", '--absolute-path', :ABSOLUTE_PATH
    include_context "pattern option", '--path', :PATH
    include_context "pattern option", '-P', :PATH

    #
    # Source Code pattern options
    #
    include_context "pattern option", '--identifier', :IDENTIFIER
    include_context "pattern option", '--variable-name', :VARIABLE_NAME
    include_context "pattern option", '--variable-assignment', :VARIABLE_ASSIGNMENT
    include_context "pattern option", '--function-name', :FUNCTION_NAME
    include_context "pattern option", '--single-quoted-string', :SINGLE_QUOTED_STRING
    include_context "pattern option", '--double-quoted-string', :DOUBLE_QUOTED_STRING
    include_context "pattern option", '--string', :STRING
    include_context "pattern option", '-S', :STRING
    include_context "pattern option", '--base64', :BASE64
    include_context "pattern option", '-B', :BASE64
    include_context "pattern option", '--c-comment', :C_COMMENT
    include_context "pattern option", '--cpp-comment', :CPP_COMMENT
    include_context "pattern option", '--java-comment', :JAVA_COMMENT
    include_context "pattern option", '--javascript-comment', :JAVASCRIPT_COMMENT
    include_context "pattern option", '--shell-comment', :SHELL_COMMENT
    include_context "pattern option", '--ruby-comment', :RUBY_COMMENT
    include_context "pattern option", '--python-comment', :PYTHON_COMMENT
    include_context "pattern option", '--comment', :COMMENT

    #
    # Cryptographic pattern options
    #
    include_context "pattern option", '--md5', :MD5
    include_context "pattern option", '--sha1', :SHA1
    include_context "pattern option", '--sha256', :SHA256
    include_context "pattern option", '--sha512', :SHA512
    include_context "pattern option", '--hash', :HASH
    include_context "pattern option", '--ssh-public-key', :SSH_PUBLIC_KEY
    include_context "pattern option", '--public-key', :PUBLIC_KEY

    #
    # Credentials pattern options
    #
    include_context "pattern option", '--ssh-private-key', :SSH_PRIVATE_KEY
    include_context "pattern option", '--dsa-private-key', :DSA_PRIVATE_KEY
    include_context "pattern option", '--ec-private-key', :EC_PRIVATE_KEY
    include_context "pattern option", '--rsa-private-key', :RSA_PRIVATE_KEY
    include_context "pattern option", '--private-key', :PRIVATE_KEY
    include_context "pattern option", '-K', :PRIVATE_KEY
    include_context "pattern option", '--aws-access-key-id', :AWS_ACCESS_KEY_ID
    include_context "pattern option", '--aws-secret-access-key', :AWS_SECRET_ACCESS_KEY
    include_context "pattern option", '--api-key', :API_KEY
    include_context "pattern option", '-A', :API_KEY

    #
    # General options
    #
    context "when givne '-e /regexp/'" do
      let(:regexp) { /foo/ }

      before do
        subject.option_parser.parse(['-e', regexp.inspect])
      end

      it "must set #pattern to the given regexp" do
        expect(subject.pattern).to eq(regexp)
      end
    end

    context "when givne '--regexp /regexp/'" do
      let(:regexp) { /foo/ }

      before do
        subject.option_parser.parse(['--regexp', regexp.inspect])
      end

      it "must set #pattern to the given regexp" do
        expect(subject.pattern).to eq(regexp)
      end
    end
  end
end
