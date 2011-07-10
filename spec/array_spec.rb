
require 'spec_helper'


describe Subaltern do

  describe '[]' do

    it 'returns the array' do

      Subaltern.eval('[]').should == []
      Subaltern.eval('[ 1, 2 ]').should == [ 1, 2 ]
    end
  end

  describe 'arrays' do

    it 'are mostly trusted' do

      Subaltern.eval('[ 1, 2, 3 ].length').should == 3
      Subaltern.eval('[ 1, [ 2, 3 ] ].flatten').should == [ 1, 2, 3 ]
    end

    describe '#inject' do

      it 'works OK' do

        Subaltern.eval(%[
          [ 1, 2, 3 ].inject(0) { |sum, e| sum + e }
        ]).should == [ 2, 3, 4 ]
      end
    end

    describe '#collect' do

      it 'works OK' do

        Subaltern.eval(%[
          [ 1, 2, 3 ].collect { |e| e + 1 }
        ]).should == [ 2, 3, 4 ]
      end
    end

    describe '#select' do

      it 'works OK' do

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
