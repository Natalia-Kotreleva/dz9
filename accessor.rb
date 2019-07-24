# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(arg)
      history ||= []
      define_method(arg.to_s) { instance_variable_get("@#{arg}") }
      define_method("#{arg}=") do |value|
        instance_variable_set("@#{arg}", value)
        history << value
        instance_variable_set("@#{arg}_history", history)
      end
    end

    def strong_attr_accessor(arg, type)
      define_method(arg.to_s) { instance_variable_get("@#{arg}") }
      define_method ("#{arg}=") do |value|
        raise 'Type Error' if value.class.to_s != type

        instance_variable_set("@#{arg}", value)
      end
    end

    def attr_accessor_method(arg)
      define_method(arg.to_s) { instance_variable_get("@#{arg}") }
      define_method ("#{arg}=") { |value| instance_variable_set("@#{arg}", value) }
    end
  end
end

class A
  include Accessors
  def initialize(*arg); end
end

A.attr_accessor_with_history('dd') # create attr_accessor
A.attr_accessor_with_history('tdfe')

test = A.new
test.dd = 5
test.tdfe = 7865
test.dd = '6'
A.attr_accessor_method('s')
test.s = 'sd'
p test

A.strong_attr_accessor('hhh', 7.class.to_s) # create attr, check class
test.hhh = 7
p test
puts 'proverka1'
test.hhh ="fff"
p test
puts 'vse'
