# frozen_string_literal: true

module InstanceCounter
  @@register = 0

  def self.included(base)
    base.extend(ClassMethod)
    base.include(InstancesMethod)
  end

  module ClassMethod
    attr_writer :instances

    def instances
      @instances ||= 0
    end

    def count
      self.instances += 1
    end
  end

  module InstancesMethod
    def register_instance
      self.class.count
    end
  end
end
