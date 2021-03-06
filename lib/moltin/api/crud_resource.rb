require 'moltin/api/request'
require 'moltin/support/inflector'
require 'moltin/resource_collection'

module Moltin
  module Api
    class CrudResource

      def self.all
        search({})
      end

      def self.find(id)
        response = Moltin::Api::Request.get("#{resource_namespace}/#{id}")
        self.new response.result
      end

      def self.find_by(options)
        collection = search(options)
        collection.first
      end

      def self.search(options)
        query_string = options.map { |k, v| "#{k}=#{v}" }.join('&')
        results = Request.get("#{resource_namespace}/search#{query_string ? "?#{query_string}" : ''}").result
        Moltin::ResourceCollection.new name, results
      end

      def self.attributes(*attrs)
        return @attributes if attrs.count === 0
        @attributes ||= []
        attrs.each do |attr|
          @attributes.push(attr)
        end
      end

      def self.create(data)
        result = Request.post(resource_namespace, data).result
        self.new(result)
      end

      attr_reader :data

      def initialize(data = {})
        @data ||= {}
        self.class.attributes.each do |attribute|
          @data[attribute] ||= nil
        end
        data.each do |key, value|
          @data[key.to_s] = value
        end
      end

      def save
      end

      def assign_attributes
      end

      def delete
      end

      def method_missing(method, *args, &block)
        if method.to_s.index('=')
          key = method.to_s.split('=').first.gsub('_attributes', '')
          return set_attribute(key, args[0]) if self.class.attributes.include? key.to_sym
        elsif self.class.attributes.include? method
          return get_attribute(method)
        end
        super
      end

      def respond_to?(method)
        if method.to_s.index('_attributes=')
          return self.class.attributes.include?(method.to_s.split('_attributes').first.to_sym)
        end
        return true if self.class.attributes.include? method.to_sym
        super
      end

      def to_s
        _data = {}
        @data.keys.each do |attribute|
          _data[attribute] = send(attribute)
        end
        _data
      end

      def to_hash
        to_s
      end

      private

      def self.resource_name
        name.to_s.downcase.gsub("moltin::resource::", "")
      end

      def self.resource_namespace
        Moltin::Support::Inflector.pluralize(resource_name)
      end

      def set_attribute(key, value)
        @data[key.to_s] = value
      end

      def get_attribute(key)
        key = key.to_s
        return nil unless @data[key]
        if @data[key].is_a? Hash
          return @data[key]['value']
        end
        @data[key]
      end
    end
  end
end
