
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
  end
end

