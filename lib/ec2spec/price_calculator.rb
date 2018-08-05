module Ec2spec
  class PriceCalculator
    def initialize(instance_type)
      @instance_type = instance_type
    end

    def price_per_unit; end
  end
end
