module Ec2spec
  class Client
    META_DATA_INSTANCE_TYPE_URL = 'http://169.254.169.254/latest/meta-data/instance-type'
    META_DATA_INSTANCE_ID_URL   = 'http://169.254.169.254/latest/meta-data/instance-id'

    TABLE_LABEL_WITH_METHODS = {
      'instance_type' => :instance_type,
      'instance_id'   => :instance_id,
      'memory'        => :memory,
      'price (USD/H)' => :price_per_unit,
      'price (USD/M)' => :price_per_month,
    }

    def initialize(hosts)
      @hosts = hosts
    end

    def run
      hosts = @hosts.map { |host| target(host) }
      threads = hosts.map do |host|
        Thread.start(host.backend) do |backend|
          exec_host_result(host, backend)
        end
      end
      @results = threads.each(&:join)
      output
    end

    private

    def exec_host_result(host, backend)
      begin
        host.instance_type = instance_type(backend)
        host.instance_id   = instance_id(backend)
        host.memory = memory(backend)
      rescue Errno::ECONNREFUSED
        host.na_values
      end
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

    def instance_type_cmd
      "curl #{META_DATA_INSTANCE_TYPE_URL}"
    end

    def instance_id_cmd
      "curl #{META_DATA_INSTANCE_ID_URL}"
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
      TABLE_LABEL_WITH_METHODS.each_with_object([]) do |(k, v), row|
        row << [k].concat(results.map(&v))
      end
    end
  end
end
