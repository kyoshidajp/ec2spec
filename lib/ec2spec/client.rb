require 'logger'
require 'ec2spec/json_formatter'
require 'ec2spec/plain_text_formatter'

module Ec2spec
  class Client
    META_DATA_URL_BASE = 'http://169.254.169.254/latest/meta-data/'
    META_DATA_INSTANCE_TYPE_PATH = '/instance-type'
    META_DATA_INSTANCE_ID_PATH   = '/instance-id'

    OUTPUT_FORMATTERS = {
      plain_text: PlainTextFormatter,
      json: JsonFormatter,
    }

    TABLE_LABEL_WITH_METHODS = {
      'instance_type' => :instance_type,
      'instance_id'   => :instance_id,
      'memory'        => :memory,
      'price (USD/H)' => :price_per_unit,
      'price (USD/M)' => :price_per_month,
    }

    def initialize(hosts, days, format)
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @hosts = hosts
      @days = days

      formatter = OUTPUT_FORMATTERS[format.to_sym]
      extend formatter
    end

    def run
      hosts = @hosts.map { |host| target(host) }
      threads = hosts.map do |host|
        Thread.start(host.backend) do |backend|
          exec_host_result(host, backend)
        end
      end
      @results = threads.each(&:join)
      output(@results, @hosts)
    end

    private

    def exec_host_result(host, backend)
      @log.info("Started: #{host.host}")

      begin
        host.instance_type = instance_type(backend)
        host.instance_id   = instance_id(backend)
        host.memory = memory(backend)
      rescue Errno::ECONNREFUSED
        host.na_values
      end

      @log.info("Finished: #{host.host}")
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

    def memory(backend)
      Specinfra::HostInventory::Memory.new(backend.host_inventory).get['total']
    end

    def target(host_name)
      ssh_options = Net::SSH::Config.for(host_name)
      backend = Specinfra::Backend::Ssh.new(
        host: ssh_options[:host_name],
        ssh_options: ssh_options,
      )
      host = Ec2spec::HostResult.new(host_name, @days)
      host.backend = backend
      host
    end
  end
end
