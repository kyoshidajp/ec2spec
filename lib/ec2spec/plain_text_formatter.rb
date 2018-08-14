module Ec2spec
  module PlainTextFormatter
    def output(results, hosts)
      table = Terminal::Table.new
      table.headings = table_header(results)
      table.rows = table_rows(results)
      column_count = hosts.size + 1
      column_count.times { |i| table.align_column(i, :right) }
      table
    end

    def table_header(results)
      [''].concat(results.map(&:host))
    end

    def table_rows(results)
      Ec2spec::HostResult::TABLE_LABEL_WITH_METHODS
        .each_with_object([]) do |(k, v), row|
        row << [k].concat(results.map(&v))
      end
    end
  end
end
