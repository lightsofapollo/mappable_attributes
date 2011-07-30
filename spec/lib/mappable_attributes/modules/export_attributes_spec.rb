require 'spec_helper'
require 'mappable_attributes/modules/export_attributes'

describe MappableAttributes::Modules::ExportAttributes do

  let(:klass) do

    Class.new do
      attr_accessor :attributes
      include MappableAttributes::Modules::ExportAttributes
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

    before do
      klass.setup_attribute_map do
        map :name => :first_name
      end

      instance.attributes = {:first_name => 'James'}
    end

    it "should export attributes" do
      instance.export_attributes.should == {:name => 'James'}.with_indifferent_access
    end

    it "should allow options" do
      expected = {:prefix_name => 'James'}.with_indifferent_access
      instance.export_attributes(:prefix => 'prefix_').should == expected
    end

  end


end


