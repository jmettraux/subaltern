
require 'spec_helper'


describe Subaltern do

  describe '{}' do

    it 'returns the hash' do

      Subaltern.eval('{}').should == {}
      Subaltern.eval('{ 1 => 2, 3 => 4 }').should == { 1 => 2, 3 => 4 }
    end
  end

  describe Hash do

    describe '#[]' do

      it 'works' do

        Subaltern.eval('{}["a"]').should == nil
        Subaltern.eval('{ "a" => 1 }["a"]').should == 1
      end
    end

    describe '.{key} (javascripty)' do

      it 'works' do

        Subaltern.eval('{ "a" => 1 }.a').should == 1
        Subaltern.eval('{ "length" => "zero" }.length').should == 1
      end
    end
  end
end

