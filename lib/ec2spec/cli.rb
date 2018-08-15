require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ssh -h host1 ...', 'Compare the specifications of EC2 instances.'
    option 'host', aliases: 'h', type: :array, equired: true
    option 'days', type: :numeric
    option 'format'
    option 'region'
    option 'debug', type: :boolean

    # rubocop:disable Metrics/AbcSize
    def ssh
      hosts = options['host']
      days = options['days']
      format = options['format'] || :plain_text
      region = options['region'] || 'ap-northeast-1'

      Ec2spec.logger.level = Logger::DEBUG if options['debug']
      client = Ec2spec::Client.new(hosts, days, format, region)
      puts client.run
    end
    # rubocop:enable Metrics/AbcSize
  end
end
