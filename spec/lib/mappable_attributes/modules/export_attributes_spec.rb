require 'spec_helper'
require 'mappable_attributes/modules/export_attributes'

describe MappableAttributes::Modules::ExportAttributes do

  let(:klass) do

    Class.new do
      attr_accessor :attributes
      include MappableAttributes::Modules::ExportAttributes

      def my_method
        :method
      end

    end
  end

  it "should have setup cattr_reader for attribute map on attribute_map" do
    klass.attribute_map.should be_an(MappableAttributes::Base)
  end

  describe "#self.setup_attribute_map" do

    before do
      context = nil
      klass.setup_attribute_map do
        context = self
      end
      @context = context
    end

    it "should execute within the context of the mappable attributes base" do
      @context.should === klass.attribute_map
    end

  end

  describe "#export_attributes" do

    let(:instance) do
      klass.new
    end

    let(:result) do
      instance.export_attributes
    end

    before do
      klass.setup_attribute_map do
        map :name => :first_name
      end

      instance.attributes = {:first_name => 'James'}
    end

    it "should export attributes" do
      result.should == {:name => 'James'}.with_indifferent_access
    end

    context "with options" do

      it "should allow options" do
        expected = {:prefix_name => 'James'}.with_indifferent_access
        instance.export_attributes(nil, :prefix => 'prefix_').should == expected
      end

    end

    context "with an assignment" do

      before do
        klass.setup_attribute_map do
          assign :dynamic do
            my_method
          end
        end
      end

      it "should execute assignments in the context of the extended object" do
        result[:dynamic].should == :method
      end

    end


    context "with a given hash" do

      before do
        klass.setup_attribute_map do
          allow :city
        end
      end

      it "should use given attributes over assumed attributes" do
        expected = {:city => 'Portland', :name => nil}.with_indifferent_access
        instance.export_attributes({:city => 'Portland'}).should == expected
      end

    end


  end


end


