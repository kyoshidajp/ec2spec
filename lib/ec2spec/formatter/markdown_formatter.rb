require 'ec2spec/formatter/plain_text_formatter'

module Ec2spec
  module Formatter
    module MarkdownFormatter
      include Ec2spec::Formatter::PlainTextFormatter

      def output(results, _hosts)
        table = super
        table.style = { border_i: '|', border_top: false, border_bottom: false }
        table
      end
    end
  end
end
