require 'money'
require 'money/bank/open_exchange_rates_bank'

module Ec2spec
  module Calculator
    module ApiPriceCalculator
      OXR_CACHE = 'oxr.json'

      def currency_unit
        @currency_unit
      end

      def currency_unit_price(dollar_price)
        Money.new(dollar_price * 100, :USD).exchange_to(currency_unit)
      end

      def project_dir
        File.join(ENV['HOME'], Const::PROJECT_DIR)
      end

      def cache_file
        File.join(project_dir, OXR_CACHE)
      end

      def prepare_exchange_api(app_id)
        prepare_money(app_id)
      end

      def prepare_money(app_id)
        Money.infinite_precision = true
        oxr = Money::Bank::OpenExchangeRatesBank.new
        oxr.app_id = app_id
        oxr.cache = cache_file
        oxr.update_rates
        Money.default_bank = oxr
      end
    end
  end
end
