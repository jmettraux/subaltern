
require 'spec_helper'


describe Subaltern do

  describe 'add_methods' do

    it 'adds method to a target instance' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(x)
          end
        })

      o.should respond_to(:foo)
    end

    it 'adds methods to a target instance' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(x)
          end
          def bar(y)
          end
        })

      o.should respond_to(:foo)
      o.should respond_to(:bar)
    end

    it 'lets those methods get called' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(bar)
            :x
          end
        })

      o.foo(nil).should == :x
    end

    it 'lets those methods get called with arguments' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(bar)
            bar
          end
        })

      o.foo(:kessennuma).should == :kessennuma
    end

    it 'adds methods to a target instance' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(x)
          end
          def bar(y)
          end
        })

      o.should respond_to(:foo)
      o.should respond_to(:bar)
    end

    it 'lets those methods get called' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(bar)
            :x
          end
        })

      o.foo(nil).should == :x
    end

    it 'lets those methods get called with arguments' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo(bar)
            bar
          end
        })

      o.foo(:kessennuma).should == :kessennuma
    end

    it 'raises on evil code (when calling)' do

      o = Object.new

      Subaltern.add_methods(
        o,
        %{
          def foo
            ''.eval('1')
          end
        })

      lambda {
        o.foo
      }.should raise_error(Subaltern::NonWhitelistedMethodError)
    end
  end
end

