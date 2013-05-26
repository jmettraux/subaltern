
require 'spec_helper'


describe Subaltern do

  describe Subaltern::Context do

    describe '.new' do

      it 'is OK not to pass initial variables' do

        Subaltern::Context.new.eval('1 + 1').should == 2
      end

      it 'is OK to pass initial variables' do

        Subaltern::Context.new(:a => 7).eval('a + 1').should == 8
      end
    end
  end
end

