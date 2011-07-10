
require 'spec_helper'


describe Subaltern do

  context 'with Fixnum' do

    it 'evaluates almost freely' do

      Subaltern.eval('1.0').should == 1.0
      Subaltern.eval('1 + 1').should == 2
      Subaltern.eval('1 * 2').should == 2
      Subaltern.eval('3 - 1').should == 2
      Subaltern.eval('1.even?').should == false
      Subaltern.eval('1.odd?').should == true
    end
  end
end

