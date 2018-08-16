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
    option 'app_id'
    option 'calc_type'
    option 'debug', type: :boolean

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def ssh
      hosts = options['host']
      days = options['days']
      rate = options['rate']
      unit = options['unit']
      app_id = options['app_id']
      calc_type = options['calc_type']
      format = options['format'] || :plain_text
      region = options['region'] || 'ap-northeast-1'

      Ec2spec.logger.level = Logger::DEBUG if options['debug']
      client = Ec2spec::Client.new(hosts, days, format, region)
      client.prepare_price_calculator(unit, rate, calc_type, app_id) if rate && unit
      puts client.run
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
