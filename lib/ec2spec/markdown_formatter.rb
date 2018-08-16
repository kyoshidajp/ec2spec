require 'ec2spec/plain_text_formatter'

module Ec2spec
  module MarkdownFormatter
    include Ec2spec::PlainTextFormatter

    def output(results, _hosts)
      table = super
      table.style = { border_i: '|', border_top: false, border_bottom: false }
      table
    end
  end
end
