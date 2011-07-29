require 'spec_helper'

describe MappableAttributes::Base do

  describe "#initialize" do

    before do
      subject.mapped[:zomg] = 'wow'
    end

    it "should allow access to mapped field via symbols" do
      subject.mapped[:zomg].should == 'wow'
    end

    it "should allow access to mapped fields via strings" do
      subject.mapped['zomg'].should == 'wow'
    end

    context "when initializing with a block" do

      before do
        
        context = nil
        @object = described_class.new do
          context = self

          map :key => :value
        end

        @context = context

      end

      it "should execute block given to initialize in context of self" do
        @context.should == @object
      end

      it "should successfully map attributes inside initializer" do
        @object.mapped[:key].should == :value
      end

    end

  end


  describe "#map" do

    context "when using with hashes" do

      before do
        subject.map :out => :in, :out2 => :in2
      end

      it "should add key value pairs to mapped" do
        subject.mapped.should == {:out => :in, :out2 => :in2}.with_indifferent_access
      end

    end

    context "when using with key, block pair" do

      let(:block) do
        proc {}
      end


      before do
        subject.map(:zomg, &block)
      end

      it "should have saved block to mapped" do
        subject.mapped[:zomg].object_id.should == block.object_id
      end

    end

  end

  describe "#manipulate_key_name" do

    let(:key) { :name }

    context "when altering key without options" do


      it "should return given key" do
        subject.send(:manipulate_key_name, key).should == key
      end

    end

    context "when using a prefix" do
    
      it "should add prefix to key name" do
        expected = "pre_#{key}".to_sym
        subject.send(:manipulate_key_name, key, :prefix => 'pre_').should == expected
      end

    end



  end

  describe "#map_attributes" do

    let(:given) do
      {:full_name => 'first last'}
    end

    let(:expected) do
      {
        :full_name => 'first last',
        :name => 'first last',
        :first_name => 'first', 
        :last_name => 'last',
        :blank => nil
      }
    end

    let(:result) do
      subject.map_attributes(given)
    end

    before do
      subject.map :name => :full_name

      subject.map :full_name do |hash, new_hash|
        split = hash['full_name'].split(" ")
        new_hash[:first_name] = split[0]
        new_hash[:last_name] = split[1]

        hash['full_name']
      end

      subject.map :blank => :notthere

    end

    it "should create expected hash" do
      result.should == expected.with_indifferent_access
    end

    it "should add mapped elements to response even if input key is missing" do
      result[:blank].should == nil
    end
  
    context "when given a prefix" do

      let(:expected) do
        {
          :p_name => 'first last',
          :p_blank => nil
        }
      end

      before do
        subject.mapped.delete(:full_name)
      end

      it "should create expected hash with prefixes" do
        subject.map_attributes(given, :prefix => 'p_').should == expected.with_indifferent_access
      end
      

    end

  end

end
