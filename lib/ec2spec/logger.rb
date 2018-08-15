require 'logger'

module Ec2spec
  @logger = ::Logger.new($stdout)
  @logger.level = Logger::INFO

  class << self
    attr_accessor :logger
  end
end
