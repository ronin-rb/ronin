require 'spec_helper'
require 'ronin/cli/commands/url'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Url do
  include_examples "man_page"

  describe "#process_value" do
    let(:url) { "https://user:password@example.com:8080/page.php?q=1#fragment" }
    let(:uri) { URI.parse(url) }

    context "when the --user option is given" do
      before { subject.options[:user] = true }

      it "must print the username of the URL" do
        expect {
          subject.process_value(url)
        }.to output(uri.user + $/).to_stdout
      end
    end

    context "when the --password option is given" do
      before { subject.options[:password] = true }

      it "must print the password of the URL" do
        expect {
          subject.process_value(url)
        }.to output(uri.password + $/).to_stdout
      end
    end

    context "when the --user-password option is given" do
      before { subject.options[:user_password] = true }

      it "must print the username and password of the URL" do
        expect {
          subject.process_value(url)
        }.to output("#{uri.user}:#{uri.password}#{$/}").to_stdout
      end
    end

    context "when the --host option is given" do
      before { subject.options[:host] = true }

      it "must print the host of the URL" do
        expect {
          subject.process_value(url)
        }.to output(uri.host + $/).to_stdout
      end
    end

    context "when the --host-port option is given" do
      before { subject.options[:host_port] = true }

      it "must print the host and port of the URL" do
        expect {
          subject.process_value(url)
        }.to output("#{uri.host}:#{uri.port}#{$/}").to_stdout
      end
    end

    context "when the --path option is given" do
      before { subject.options[:path] = true }

      it "must print the path of the URL" do
        expect {
          subject.process_value(url)
        }.to output(uri.path + $/).to_stdout
      end
    end

    context "when the --query option is given" do
      before { subject.options[:query] = true }

      it "must print the query of the URL" do
        expect {
          subject.process_value(url)
        }.to output(uri.query + $/).to_stdout
      end
    end

    context "when the --path-query option is given" do
      before { subject.options[:path_query] = true }

      it "must print the path and query of the URL" do
        expect {
          subject.process_value(url)
        }.to output("#{uri.path}?#{uri.query}#{$/}").to_stdout
      end
    end

    context "when the --fragment option is given" do
      before { subject.options[:fragment] = true }

      it "must print the fragment of the URL" do
        expect {
          subject.process_value(url)
        }.to output(uri.fragment + $/).to_stdout
      end
    end

    context "when the --status option is given", :integration do
      let(:url) { "https://example.com/" }

      before { subject.options[:status] = true }

      it "must print the HTTP status of the URI" do
        expect {
          subject.process_value(url)
        }.to output("200 #{url}#{$/}").to_stdout
      end

      context "when a network exception occurs" do
        let(:url) { "https://does.not.exist/" }
        let(:error) do
          "Failed to open TCP connection to does.not.exist:443 (getaddrinfo: Name or service not known)"
        end

        it "must print the URL and an error message to stderr" do
          expect {
            subject.process_value(url)
          }.to output("#{url}: #{error}#{$/}").to_stderr
        end
      end
    end

    context "when no options are given" do
      it "must print the URL to stdout" do
        expect {
          subject.process_value(url)
        }.to output(url + $/).to_stdout
      end
    end
  end
end
