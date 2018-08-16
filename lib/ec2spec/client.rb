require 'ec2spec/formatter/json_formatter'
require 'ec2spec/formatter/markdown_formatter'
require 'ec2spec/formatter/plain_text_formatter'
require 'ec2spec/formatter/hash_formatter'
require 'ec2spec/formatter/slack_formatter'

module Ec2spec
  class UndefineFormatterError < StandardError; end

  class Client
    META_DATA_URL_BASE = 'http://169.254.169.254/latest/meta-data/'
    META_DATA_INSTANCE_TYPE_PATH = '/instance-type'
    META_DATA_INSTANCE_ID_PATH   = '/instance-id'
    DEFAULT_REGION = 'ap-northeast-1'

    OUTPUT_FORMATTERS = {
      plain_text: Formatter::PlainTextFormatter,
      json:       Formatter::JsonFormatter,
      hash:       Formatter::HashFormatter,
      slack:      Formatter::SlackFormatter,
      markdown:   Formatter::MarkdownFormatter,
    }

    CONNECTION_ERROR_WITH_MESSAGES = {
      Errno::ECONNREFUSED         => 'Connection refused: %{host}',
      Net::SSH::ConnectionTimeout => 'Connection timeout: %{host}',
      StandardError               => 'Unknown error: %{host}',
    }

    def initialize(hosts, days, format, region = DEFAULT_REGION)
      @hosts = hosts
      @days = days
      @format = format
      @region = region

      extend_formatter
      OfferFile.instance.prepare(@region)
    end

    def run
      hosts = @hosts.map { |host| target(host) }
      threads = hosts.map do |host|
        Thread.start(host.backend) do |backend|
          exec_host_result(host, backend)
        end
      end
      results = threads.each(&:join).map(&:value)
      output(results, @hosts)
    end

    private

    def extend_formatter
      format_sym = begin
        @format.to_sym
      rescue NoMethodError
        raise UndefineFormatterError
      end

      raise UndefineFormatterError unless OUTPUT_FORMATTERS.key?(format_sym)
      extend OUTPUT_FORMATTERS[format_sym]
    end

    def host_result(host, backend)
      Ec2spec.logger.info("Finished: #{host.host}")
      host.instance_type = instance_type(backend)
      host.instance_id   = instance_id(backend)
    rescue *CONNECTION_ERROR_WITH_MESSAGES.keys => e
      message = format(CONNECTION_ERROR_WITH_MESSAGES[e.class], host: host.host)
      Ec2spec.logger.error(message)
      host.na_values
    end

    def exec_host_result(host, backend)
      Ec2spec.logger.info("Started: #{host.host}")
      host_result(host, backend)
      host
    end

    def instance_type(backend)
      cmd_result = backend.run_command(instance_type_cmd)
      cmd_result.stdout
    end

    def instance_id(backend)
      cmd_result = backend.run_command(instance_id_cmd)
      cmd_result.stdout
    end

    def metadata_url(path)
      "#{META_DATA_URL_BASE}#{path}"
    end

    def instance_type_cmd
      "curl -s #{metadata_url(META_DATA_INSTANCE_TYPE_PATH)}"
    end

    def instance_id_cmd
      "curl -s #{metadata_url(META_DATA_INSTANCE_ID_PATH)}"
    end

    def target(host_name)
      ssh_options = Net::SSH::Config.for(host_name)
      backend = Specinfra::Backend::Ssh.new(
        host: ssh_options[:host_name],
        ssh_options: ssh_options,
      )
      host = Ec2spec::HostResult.new(@region, host_name, @days)
      host.backend = backend
      host
    end
  end
end
