require 'singleton'
require 'ec2spec/calculator/api_price_calculator'
require 'ec2spec/calculator/manual_price_calculator'

module Ec2spec
  class PriceCalculator
    include Singleton

    class UndefinedCalcError < StandardError; end
    class ApiKeyError < StandardError; end

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

      if calc_type == :api
        raise ApiKeyError if !app_id.nil?
        prepare_exchange_api(app_id)
      end
    end

    def currency_values?
      !(@currency_unit.nil? || @dollar_exchange_rate.nil?)
    end

    private

    def extend_calc
      calc_type_sym = begin
        @calc_type.to_sym
      rescue NoMethodError
        raise UndefinedCalcError
      end

      raise UndefinedCalcError unless PRICE_CALCULATORS.key?(calc_type_sym)
      extend PRICE_CALCULATORS[calc_type_sym]
      Ec2spec.logger.debug("Calculate price: #{@calc_type}")
    end
  end
end
