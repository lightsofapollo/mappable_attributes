module MappableAttributes
  module Modules
    module ExportAttributes
      extend ActiveSupport::Concern

      require 'active_support/core_ext/class/attribute_accessors'

      included do
        cattr_accessor :attribute_map

        self.attribute_map = MappableAttributes::Base.new
      end

      # Runs map_attributes on the attributes method
      #
      # @param [Hash] options for map_attributes
      # @returns [Hash] mapped attributes
      def export_attributes(options = {})
        attribute_map.map_attributes(attributes, options)
      end

      module ClassMethods
        
        # Simple DSL for setting up the MappableAttribute::Base
        # object on the class.
        def setup_attribute_map(&block)
          if(block_given?)
            attribute_map.instance_eval(&block)
          end
        end

      end

    end
  end
end
