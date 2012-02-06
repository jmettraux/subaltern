
require 'spec_helper'


class String
  def constantize
    eval(self)
  end
end

describe Subaltern do

  context 'evil' do

    describe "eval('1 + 1')" do

      it 'raises' do

        lambda {
          Subaltern.eval("eval('1 + 1')")
        }.should raise_error(Subaltern::UndefinedVariableError)
      end
    end

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

    describe 'a constant lookup' do

      it 'raises (ENV)' do

        lambda {
          Subaltern.eval('ENV')
        }.should raise_error(Subaltern::AccessError)
      end

      it 'raises (File::Utils)' do

        lambda {
          Subaltern.eval('File::Utils')
        }.should raise_error(Subaltern::AccessError)
      end
    end

    describe 'a call on a constant' do

      it 'raises (ENV["HOME"])' do

        lambda {
          Subaltern.eval('ENV["HOME"]')
        }.should raise_error(Subaltern::AccessError)
      end
    end

    describe 'a global variable lookup' do

      it 'raises ($nada)' do

        lambda {
          Subaltern.eval('$nada')
        }.should raise_error(Subaltern::AccessError)
      end
    end

    describe 'backquoting' do

      it 'raises (simple case)' do

        lambda {
          Subaltern.eval('`ls -al`')
        }.should raise_error(Subaltern::AccessError)
      end

      it 'raises (string extrapolation case)' do

        lambda {
          Subaltern.eval('`ls -al #{nada}`')
        }.should raise_error(Subaltern::AccessError)
      end
    end

    describe 'method with a block' do

      it 'is not automatically whitelisted' do

        class Array
          def whatever
          end
        end

        lambda {
          Subaltern.eval('[].whatever { |e| false }')
        }.should raise_error(Subaltern::NonWhitelistedMethodError)
      end
    end
  end
end

