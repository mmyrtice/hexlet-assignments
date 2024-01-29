# frozen_string_literal: true

# BEGIN
require 'date'

module Model
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attribute(name, options = {})
      default_value = options.key?(:default) ? options[:default] : nil
      attributes_list[name] = options.merge(default: default_value)
      define_method(name) { @attributes.key?(name) ? @attributes[name] : options[:default] }
      define_method("#{name}=") { |value| @attributes[name] = convert_value(value, options[:type]) }
    end

    def attributes_list
      @attributes_list ||= {}
    end
  end

  module InstanceMethods
    def initialize(attributes = {})
      @attributes = {}
      set_attributes(attributes)
    end

    def attributes
      result = {}
      self.class.attributes_list.each do |name, options|
        result[name] = convert_value(@attributes[name], options[:type]) || options[:default]
      end
      result
    end

    private

    def set_attributes(attributes)
      attributes.each do |name, value|
        next unless self.class.attributes_list.key?(name)

        @attributes[name] = convert_value(value, self.class.attributes_list[name][:type])
      end
    end

    def convert_value(value, type)
      case type
      when :integer
        value.to_i unless value.nil?
      when :string
        value.to_s unless value.nil?
      when :boolean
        value.nil? ? nil : value.to_s.downcase == 'true'
      when :datetime
        value.is_a?(::DateTime) ? value : ::DateTime.parse(value.to_s) rescue nil
      else
        value
      end
    end
  end
end

# END
