
require 'spec_helper'


describe Subaltern do

  context 'basics' do

    describe 'bad syntax' do

      it 'raises a Racc::ParseError' do

        lambda {
          Subaltern.eval('adsfad:12')
        }.should raise_error(Racc::ParseError)
      end
    end

    describe 'literals, strings, booleans' do

      it 'returns the literal' do

        [
          1, "hello", 1.0, true, false, nil
        ].each do |lit|
          Subaltern.eval(lit.inspect).should == lit
        end
      end
    end

    describe '1 + 1' do

      it 'evals to 2' do

        r = Subaltern.eval(%{
          1 + 1
        })

        r.should == 2
      end
    end

    describe '[]' do

      it 'return the array' do

        Subaltern.eval('[]').should == []
        Subaltern.eval('[ 1, 2 ]').should == [ 1, 2 ]
      end
    end

    describe '{}' do

      it 'return the array' do

        Subaltern.eval('{}').should == {}
        Subaltern.eval('{ 1 => 2, 3 => 4 }').should == { 1 => 2, 3 => 4 }
      end
    end
  end
end

