require 'logger'

module Ec2spec
  @logger = ::Logger.new($stdout)

  class << self
    attr_reader :logger
  end
end
