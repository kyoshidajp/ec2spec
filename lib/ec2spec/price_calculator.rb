require 'singleton'
require 'ec2spec/calculator/api_price_calculator'
require 'ec2spec/calculator/manual_price_calculator'

module Ec2spec
  class UndefinedCalcError < StandardError; end
  class ApiKeyError < StandardError; end

  class PriceCalculator
    include Singleton

    attr_accessor :currency_unit, :dollar_exchange_rate

    PRICE_CALCULATORS = {
      manual: Calculator::ManualPriceCalculator,
      api:    Calculator::ApiPriceCalculator,
    }

    def initialize
      @currency_unit = nil
      @dollar_exchange_rate = nil
      @app_id = nil
    end

    def prepare(unit, rate, calc_type = :manual, app_id = nil)
      @currency_unit = unit
      @dollar_exchange_rate = rate
      @app_id = app_id
      @calc_type = calc_type

      extend_calc

      raise ApiKeyError if calc_type_sym == :api && app_id.nil?
      prepare_exchange_api(app_id) if calc_type == :api
      self
    end

    def currency_values?
      !(@currency_unit.nil? || @dollar_exchange_rate.nil?)
    end

    private

    def extend_calc
      raise UndefinedCalcError unless PRICE_CALCULATORS.key?(calc_type_sym)
      extend PRICE_CALCULATORS[calc_type_sym]
      Ec2spec.logger.debug("Calculate price: #{@calc_type}")
    end

    def calc_type_sym
      @calc_type.to_sym
    rescue NoMethodError
      raise UndefinedCalcError
    end
  end
end
