module MappableAttributes
  class Base
    attr_reader :mapped

    def initialize(&block)
      @mapped = {}.with_indifferent_access
      if(block_given?)
        instance_eval(&block)
      end
    end

    # Output field names to input field names
    #
    #     # Maps key value pairs as output => input
    #     map :output_name => :input_name, ...
    #
    #     # Maps a key to lambda that later determines value
    #     # This is equivalent to the above.
    #     map :output_name do |hash|
    #       hash[:input_name]
    #     end
    #
    #
    # @param [Hash, Symbol] hash of key value pairs, or a symbol
    # @param [Block] Block given when a symbol is used as first param 
    #
    def map(hash, &block)
      if(hash.is_a?(Symbol))
        @mapped[hash] = block
      else
        @mapped.merge!(hash)
      end
    end

    # Returns a mapped list of attributes from a given hash
    # All keys evaulated with_indifferent_access
    #
    # @param [Hash] given attributes to map
    # @param [Hash] hash of options see manipulate_key_name
    # @returns [Hash] Outputs a mapped hash acording to rules set by map
    def map_attributes(attributes, options = {})
      new_attributes = {}.with_indifferent_access
      original_attributes = attributes.clone.with_indifferent_access

      mapped.each do |new_key, old_key|
        key_name = manipulate_key_name(new_key, options)

        if(old_key.respond_to?(:call))
          new_attributes[key_name] = old_key.call(
            original_attributes,
            new_attributes
          )
        else
          new_attributes[key_name] = original_attributes.fetch(old_key) { nil }
        end
      end

      new_attributes

    end

    protected

    # Alters the name of a given given options
    #
    #     # Adds a prefix to key
    #     :prefix => '...'
    #
    # @param [String, Symbol] name of key
    # @param [Hash] options for alteration
    # @returns [Symbol] renamed key
    def manipulate_key_name(key, options = {})
      if(options[:prefix])
        key = "#{options[:prefix]}#{key}".to_sym
      end

      key
    end

  end
end
