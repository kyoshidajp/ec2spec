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
        Money.new(dollar_price * 100, :USD).exchange_to(currency_unit).to_f
      end

      def project_dir
        File.join(ENV['HOME'], Const::PROJECT_DIR)
      end

      def mkdir_project_dir
        Dir.mkdir(project_dir) unless Dir.exist?(project_dir)
      end

      def cache_file
        File.join(project_dir, OXR_CACHE)
      end

      def prepare_exchange_api(value)
        mkdir_project_dir

        Money.infinite_precision = true
        oxr = Money::Bank::OpenExchangeRatesBank.new
        oxr.app_id = value
        oxr.cache = cache_file
        oxr.update_rates
        Money.default_bank = oxr
      end
    end
  end
end
