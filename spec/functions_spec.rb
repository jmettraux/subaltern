
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

    it 'accepts functions with starred parameters' do

      Subaltern.eval(%{
        def concat(a, *args)
          [ a ] + args
        end
        concat(1, 2, 3, 4)
      }).should == [ 1, 2, 3, 4 ]
    end

    it 'accepts a final hash argument' do

      Subaltern.eval(%{
        def pretty(a, b)
          [ a, b ]
        end
        pretty('a', 'b' => 'c')
      }).should == [ 'a', { 'b' => 'c' } ]
    end

    it 'accepts "return" in the middle of functions' do

      Subaltern.eval(%{
        def hello
          1
          return 'nada'
          2
        end
        hello
      }).should == 'nada'
    end

    it 'accepts functions with blocks' do

      Subaltern.eval(%{
        def hello
          1 + yield
        end
        hello { 3 }
      }).should == 4
    end

    it 'accepts functions with args and block' do

      Subaltern.eval(%{
        def hello(start)
          start + yield
        end
        hello(4) { 3 }
      }).should == 7
    end

    it 'accepts functions with explicit blocks' do

      Subaltern.eval(%{
        def hello(start, &block)
          start + block.call
        end
        hello(1) { 3 }
      }).should == 4
    end

    it 'accepts functions that call blocks with arguments' do

      Subaltern.eval(%{
        def hello(start, &block)
          start + block.call(start)
        end
        hello(3) { |s| s * 3 }
      }).should == 12
    end

    it 'accepts functions that yield arguments to blocks' do

      Subaltern.eval(%{
        def hello(start)
          start + yield(start)
        end
        hello(3) { |s| s * 3 }
      }).should == 12
    end

    it 'raises when a block is called without its arg' do

      lambda {
        Subaltern.eval(%{
          def hello(start, &block)
            start + block.call
          end
          hello(3) { |start| start * 3 }
        })
      }.should raise_error(Subaltern::NonWhitelistedMethodError)
    end
  end
end

