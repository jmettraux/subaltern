
require 'spec_helper'


describe Subaltern do

  describe 'Fixnum' do

    it 'works' do

      Subaltern.eval('1.0').should == 1.0
      Subaltern.eval('1 + 1').should == 2
      Subaltern.eval('1 * 2').should == 2
      Subaltern.eval('3 - 1').should == 2
      Subaltern.eval('1.even?').should == false
      Subaltern.eval('1.odd?').should == true
    end
  end
end

