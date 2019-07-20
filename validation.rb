# frozen_string_literal: true

module Validation
  def self.included(base)
    base.send :include, InstanceMethods
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_accessor :args
    def validate(arg, valid_type, *par)
      @args ||= {}
      @args["#{arg}"] = [ "#{valid_type}", "#{par}" ]
    begin
      raise 'Type Error' if arg.class != par[0] && valid_type == 'type'
      raise 'It is nil' if arg.to_s == '' && valid_type == 'presence'
      raise 'Format Error' if arg != par && valid_type == 'format'
    rescue StandardError => e
      puts e.message
    end
    end
  end

  module InstanceMethods
    def validate!
      self.class.args.each do |k, v|
        raise 'Type Error' if k.class != v[1] && v[0] == 'type'
        raise 'It is nil' if k.to_s == '' && v[0] == 'presence'
        raise 'Format Error' if k != v[1] && v[0] == 'format'
      end 
    end

    def valid?
      validate!
      rescue StandardError
      false
    end
  end
end

class D
  include Validation
  attr_accessor :name, :number
  def initialize(name, number)
    @name = name
    @number = number
  end
end

dd = D.new('as', 12)
D.validate(:name, 'type', 'as')
D.validate('', 'presence')
D.validate(12, 'format', '/a..z/')
dd.name = 'gggg'
dd.validate!
p dd.valid?

