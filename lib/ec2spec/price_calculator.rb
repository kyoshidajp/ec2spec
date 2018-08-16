require 'singleton'

module Ec2spec
  class PriceCalculator
    include Singleton

    attr_accessor :currency_unit, :dollar_exchange_rate

    def initialize
      @currency_unit = nil
      @dollar_exchange_rate = nil
    end

    def currency_unit_price(dollar_price)
      dollar_price.to_f * @dollar_exchange_rate.to_f
    end

    def currency_values?
      !(@currency_unit.nil? || @dollar_exchange_rate.nil?)
    end
  end
end
