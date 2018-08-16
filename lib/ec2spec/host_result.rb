module Ec2spec
  class HostResult
    MONTH_OF_DAYS = 31
    NA_VALUE = 'N/A'

    LABEL_WITH_METHODS = {
      'instance_type' => :instance_type,
      'instance_id'   => :instance_id,
      'vCPU'          => :vcpu,
      'memory'        => :memory,
      'price (USD/H)' => :price_per_unit,
      'price (USD/M)' => :price_per_month,
    }

    attr_accessor :host, :backend, :instance_id
    attr_reader :instance_type
    attr_writer :price_per_unit, :vcpu

    def self.label_with_methods
      label_methods = LABEL_WITH_METHODS
      if PriceCalculator.instance.currency_values?
        label_methods['price (%s/H)'] = :price_per_currency_unit
        label_methods['price (%s/M)'] = :price_per_currency_unit_month
      end
      label_methods
    end

    def initialize(region, host, days = nil)
      @region = region
      @host = host
      @backend = nil
      @days = days || MONTH_OF_DAYS
    end

    def na_values
      @instance_type = NA_VALUE
      @instance_id = NA_VALUE
      @memory = NA_VALUE
      @vcpu = NA_VALUE
      @price_per_unit = NA_VALUE
    end

    def instance_type=(value)
      @instance_type = value

      return if value == NA_VALUE
      price_per_unit
    end

    def vcpu
      @vcpu ||=
        Ec2spec::OfferFile.instance.vcpu(@instance_type)
    end

    def memory
      @memory ||=
        Ec2spec::OfferFile.instance.memory(@instance_type)
    end

    def price_per_unit
      @price_per_unit ||=
        Ec2spec::OfferFile.instance.price_per_unit(@instance_type)
    end

    def price_per_currency_unit
      return @price_per_currency_unit unless @price_per_currency_unit.nil?

      dollar_price = Ec2spec::OfferFile.instance.price_per_unit(@instance_type)
      @price_per_currency_unit = PriceCalculator
                                 .instance.currency_unit_price(dollar_price)
    end

    def price_per_month
      return NA_VALUE if @price_per_unit == NA_VALUE
      @price_per_unit * 24 * @days
    end

    def price_per_currency_unit_month
      return NA_VALUE if @price_per_currency_unit == NA_VALUE
      @price_per_currency_unit * 24 * @days
    end

    def to_hash
      host_values
    end

    private

    def host_values
      label_with_methods.each_with_object({}) do |(k, v), hash|
        unit = PriceCalculator.instance.currency_unit
        label = format(k, unit)
        hash[label] = public_send(v)
      end
    end
  end
end
