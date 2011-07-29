# What is MappableAttributes?

Often I find myself needing to rename the keys of one hash into another.

A trival example of this looks like:


    hash1 = {:werid_name => 'value'}
    hash2 = {:name => hash1[:werid_name]}

If you only need to rename one or two keys a simple approach like the
above is fine.

This library was designed for my need of renaming multiple
fields with extensability via blocks and by inherting from MappableAttributes::Base.

An example on a sudo Model.


    class SudoModel
      
      @@renamer = MappableAttributes::Base.new do
        

        map :output_name => :input_name
        map :another_name do |input|
          input[:input_name].downcase
        end

        # ....

      end

      def attributes
        {
          :input_name => 'FIRST LAST'
        }
      end

      def export_attributes
        @renamer.map_attributes(attributes)
        # =>
        # {
        #   :output_name => 'FIRST LAST',
        #   :another_name => 'first last'
        # }
      end

    end
