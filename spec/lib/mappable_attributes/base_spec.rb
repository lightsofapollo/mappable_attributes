require 'spec_helper'

describe MappableAttributes::Base do

  let(:assign_context) do
    {:contextify => 'true'}
  end

  describe "#initialize" do

    before do
      subject.mapped[:zomg] = 'wow'
    end

    it "should setup merges" do
      subject.merges.should == []
    end

    it "should setup assigned" do
      subject.assigned.should == {}.with_indifferent_access
    end
    

    it "should allow access to mapped field via symbols" do
      subject.mapped[:zomg].should == 'wow'
    end

    it "should allow access to mapped fields via strings" do
      subject.mapped['zomg'].should == 'wow'
    end

    it "should set assign_context to self by default" do
      subject.assign_context.should == subject
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

  describe "#assign" do

    let(:block) do
      proc {}
    end

    before do
      subject.assign :key, &block
    end

    it "should have added assignment to #assigned" do
      subject.assigned['key'].object_id.should == block.object_id
    end

  end

  describe "#merge" do

    let(:block) do
      proc {}
    end

    before do
      subject.merge(&block)
    end

    it "should have added block to merges" do
      subject.merges.first.should == block
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

  describe "#allow" do

    before do
      subject.allow :name, :city
    end

    it "should add allowed names into mapped" do
      expected = {:name => :name, :city => :city}.with_indifferent_access
      subject.mapped.should == expected
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
        :blank => nil
      }
    end

    let(:result) do
      subject.map_attributes(given)
    end

    context "when successful" do

      before do
        subject.map :name => :full_name

        subject.map :full_name do |hash, new_hash|
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

    end

    context "with merges" do

      let(:expected) do
        assign_context.with_indifferent_access
      end

      before do
        subject.assign_context = assign_context
        subject.merge do
          self
        end
      end

      context "with prefix" do

        let(:result) do
          subject.map_attributes(given, :prefix => 'p_')
        end

        let(:expected) do
          {:p_contextify => assign_context[:contextify]}.with_indifferent_access
        end

        it "should output expected hash" do
          result.should == expected
        end

      end

      context "without options" do

        it "should output expected hash" do
          result.should == expected
        end

      end

    end

    context "with assignments" do


      let(:result) do
        subject.map_attributes(given, :prefix => 'prefix_')
      end

      let(:expected) do
        {
          :prefix_full_name => 'first last',
          :prefix_dynamic => 'true'
        }
      end


      before do
        context = nil
        subject.assign_context = assign_context

        subject.allow :full_name

        subject.assign :dynamic do
          context = self
          self[:contextify]
        end

        result

        @context = context
      end

      it "should execute assignment block in the context of assign_context" do
        @context.should === assign_context
      end

      it "should created expected hash" do
        result.should == expected.with_indifferent_access
      end

    end
  
    context "when given a prefix" do

      let(:expected) do
        {
          :p_name => 'first last',
        }
      end

      before do
        subject.map :name => :full_name
      end

      it "should create expected hash with prefixes" do
        subject.map_attributes(given, :prefix => 'p_').should == expected.with_indifferent_access
      end
      

    end

  end

end
