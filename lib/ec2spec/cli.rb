require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ssh -h host1 ...', 'Compare the specifications of EC2 instances.'
    option 'host', aliases: 'h', type: :array, equired: true
    option 'days', type: :numeric
    option 'rate', type: :numeric
    option 'unit'
    option 'format'
    option 'region'
    option 'debug', type: :boolean

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def ssh
      hosts = options['host']
      days = options['days']
      rate = options['rate']
      unit = options['unit']
      format = options['format'] || :plain_text
      region = options['region'] || 'ap-northeast-1'

      Ec2spec.logger.level = Logger::DEBUG if options['debug']
      client = Ec2spec::Client.new(hosts, days, format, region)
      if rate && unit
        client.dollar_exchange_rate(rate)
        client.currency_unit(unit)
      end
      puts client.run
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
