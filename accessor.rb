# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end
    
  module ClassMethods
    def attr_accessor_with_history(arg)
      arg_history = "arg_history_"+"#{arg}"
      class_eval(
      "def #{arg}
        @#{arg}
      end
      def #{arg}=(value)
        @#{arg} = value
        @#{arg_history} = [] if @#{arg_history}.nil?
        @#{arg_history} << value
      end"
      )
    end

    def strong_attr_accessor(arg, type)
      class_eval(
      "def #{arg}
        @#{arg}
      end
      begin
        def #{arg}=(value)
      raise 'Type Error' if value.class != #{type}
      rescue StandardError => e
	puts e.message
        @#{arg} = value
        end
      end"
      )
    end
  end
end

class A
  include Accessors
  def initialize(*arg); end
end

A.attr_accessor_with_history('dd')
A.attr_accessor_with_history('tdfe')

test = A.new
test.dd = 5
test.tdfe = 7865
test.dd = "6"
p test

A.strong_attr_accessor('hhh', "#{1.class}")
test.hhh = 7
puts "proverka1"
test.hhh ="fff"
puts "vse"
