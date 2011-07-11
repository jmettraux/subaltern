
require 'spec_helper'


describe Subaltern do

  describe Array do

    describe '[]' do

      it 'returns the array' do

        Subaltern.eval('[]').should == []
        Subaltern.eval('[ 1, 2 ]').should == [ 1, 2 ]
      end
    end

    describe 'standard array methods' do

      it 'are accepted' do

        Subaltern.eval('[ 1, 2, 3 ].length').should == 3
        Subaltern.eval('[ 1, [ 2, 3 ] ].flatten').should == [ 1, 2, 3 ]
      end
    end

    describe '#each' do

      it 'works' do

        Subaltern.eval(%[
          sum = 0
          [ 1, 2, 3, 4 ].each(0) { |e| sum = sum + e }
          sum
        ]).should == 10
      end
    end

    describe '#inject' do

      it 'works' do

        Subaltern.eval(%[
          [ 1, 2, 3 ].inject(0) { |sum, e| sum + e }
        ]).should == [ 2, 3, 4 ]
      end
    end

    describe '#collect' do

      it 'works' do

        Subaltern.eval(%[
          [ 1, 2, 3 ].collect { |e| e + 1 }
        ]).should == [ 2, 3, 4 ]
      end
    end

    describe '#select' do

      it 'works' do

        Subaltern.eval(%[
          [ 1, 2, 3 ].select { |e| true }
        ]).should == [ 1, 2, 3 ]

        #Subaltern.eval(%[
        #  [ 1, 2, 3, 4, 5, 6, 7, 8 ].select { |e| e.even? }
        #]).should == [ 2, 4, 6, 8 ]
      end
    end
  end
end

