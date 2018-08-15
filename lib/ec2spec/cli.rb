require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ssh -h host1 ...', 'Compare the specifications of EC2 instances.'
    option 'host', aliases: 'h', type: :array, equired: true
    option 'days', type: :numeric
    option 'format'
    option 'region'
    def ssh
      hosts = options['host']
      days = options['days']
      format = options['format'] || :plain_text
      region = options['region'] || 'ap-northeast-1'
      client = Ec2spec::Client.new(hosts, days, format, region)
      puts client.run
    end
  end
end
