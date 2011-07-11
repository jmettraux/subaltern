
require 'spec_helper'


describe Subaltern do

  context 'functions' do

    it 'accepts function definitions' do

      Subaltern.eval(%{
        def addition(a, b)
          a + b
        end
      }).should == nil
    end

    it 'accepts calls to defined functions' do

      Subaltern.eval(%{
        def addition(a, b)
          a + b
        end
        addition(1, 2)
      }).should == 3
    end

    it 'accepts functions with optional parameters' do

      Subaltern.eval(%{
        def add(a, b=1, c=2)
          a + b + c
        end
        [ add(1, 2), add(4) ]
      }).should == [ 5, 7 ]
    end

    it 'accepts functions with starred parameters'

    it 'accepts "return" in the middle of functions'
  end
end

