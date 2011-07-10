
require 'spec_helper'


describe Subaltern do

  describe '1 + 1' do

    it 'evals to 2' do

      r = Subaltern.eval(%{
        1 + 1
      })

      r.should == 2
    end
  end
end

