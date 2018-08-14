module Ec2spec
  class HostResult
    MONTH_OF_DAYS = 31
    NA_VALUE = 'N/A'

    LABEL_WITH_METHODS = {
      'instance_type' => :instance_type,
      'instance_id'   => :instance_id,
      'memory'        => :memory,
      'price (USD/H)' => :price_per_unit,
      'price (USD/M)' => :price_per_month,
    }

    attr_accessor :host, :backend, :instance_id, :memory, :cpu
    attr_reader :instance_type
    attr_writer :price_per_unit

    def initialize(host, days = nil)
      @host = host
      @backend = nil
      @days = days || MONTH_OF_DAYS
    end

    def na_values
      @instance_type = NA_VALUE
      @instance_id = NA_VALUE
      @memory = NA_VALUE
      @cpu = NA_VALUE
      @price_per_unit = NA_VALUE
    end

    def instance_type=(value)
      @instance_type = value

      return if value == NA_VALUE
      @offer_file = Ec2spec::OfferFile.new(value)
      price_per_unit
    end

    def price_per_unit
      @price_per_unit ||= @offer_file.price_per_unit
    end

    def price_per_month
      return NA_VALUE if @price_per_unit == NA_VALUE
      @price_per_unit * 24 * @days
    end

    def to_hash
      host_values
    end

    private

    def host_values
      LABEL_WITH_METHODS.each_with_object({}) do |(k, v), hash|
        hash[k] = public_send(v)
      end
    end
  end
end
