
require 'spec_helper'


describe Subaltern do

  context String do

    describe 'a literal String' do

      it 'is returned as is' do

        Subaltern.eval('"123"').should == '123'
      end
    end

    describe 'string extrapolation' do

      it 'happens' do

        Subaltern.eval('"ab#{c}de"', 'c' => 'C').should == 'abCde'
      end
    end
  end
end

