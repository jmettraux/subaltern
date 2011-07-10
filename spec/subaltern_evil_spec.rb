
require 'spec_helper'


class String
  def constantize
    eval(self)
  end
end

describe Subaltern do

  context 'evil' do

    #describe '__FILE__' do
    #  it 'raises an error' do
    #    p Subaltern.eval('__FILE__')
    #  end
    #end

    describe "''.eval('1 + 1')" do

      it 'raises' do

        lambda {
          Subaltern.eval("''.eval('1 + 1')")
        }.should raise_error(Subaltern::NonWhitelistedMethodError)
      end
    end

    describe 'calls on non-whitelisted classes' do

      it 'raises' do

        lambda {
          Subaltern.eval("'File'.constantize.read('#{__FILE__}')")
        #}.should raise_error(Subaltern::NonWhitelistedClassError)
        }.should raise_error(Subaltern::NonWhitelistedMethodError)
      end
    end
  end
end

