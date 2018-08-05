require 'specinfra'
require 'terminal-table'
require 'ec2spec/cli'
require 'ec2spec/version'
require 'ec2spec/host_result'
require 'ec2spec/offer_file'
require 'ec2spec/price_calculator'


module Ec2spec
  META_DATA_URL = 'http://169.254.169.254/latest/meta-data/instance-type'

  class Client
    def initialize(hosts)
      @hosts = hosts
    end

    def run
      hosts = @hosts.map { |host| target(host) }
      threads = hosts.map do |host|
        Thread.start(host.backend) do |backend|
          host.instance_type = instance_type(backend)
          host.memory = memory(backend)
          host
        end
      end
      @results = threads.each(&:join)
      output
    end

    private

    def instance_type(backend)
      cmd_result = backend.run_command(instance_type_cmd)
      cmd_result.stdout
    end

    def instance_type_cmd
      "curl #{META_DATA_URL}"
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
      host = Ec2spec::HostResult.new(host_name)
      host.backend = backend
      host
    end

    def output
      results = @results.map(&:value)
      table = Terminal::Table.new
      table.headings = table_header(results)
      table.rows = table_rows(results)
      column_count = @hosts.size + 1
      column_count.times { |i| table.align_column(i, :right) }
      puts table
    end

    def table_header(results)
      [''].concat(results.map(&:host))
    end

    def table_rows(results)
      rows = []
      rows << ['instance_type'].concat(results.map(&:instance_type))
      rows << ['memory'].concat(results.map(&:memory))
      rows << ['price (USD/H)'].concat(results.map(&:price_per_unit))
      rows << ['price (USD/M)'].concat(results.map(&:price_per_month))
      rows
    end
  end
end
