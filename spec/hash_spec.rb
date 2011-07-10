
require 'spec_helper'


describe Subaltern do

  describe '{}' do

    it 'returns the hash' do

      Subaltern.eval('{}').should == {}
      Subaltern.eval('{ 1 => 2, 3 => 4 }').should == { 1 => 2, 3 => 4 }
    end
  end
end

