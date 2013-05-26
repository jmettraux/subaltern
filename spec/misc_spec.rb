
require 'spec_helper'


describe Subaltern do

  context 'misc' do

    describe 'nil.to_s' do

      it 'returns ""' do

        Subaltern.eval('nil.to_s').should == ''
      end
    end
  end
end

