module Ec2spec
  module Calculator
    module ManualPriceCalculator
      def currency_unit_price(dollar_price)
        dollar_price.to_f * @dollar_exchange_rate.to_f
      end
    end
  end
end
