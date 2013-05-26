
require 'spec_helper'


class Subaltern::Context

  attr_reader :variables
end


describe Subaltern::Function do

  def func(source)

    Subaltern::Function.new(Parser::CurrentRuby.parse(source))
  end

  describe '#new_context(parent_context, call_args)' do

    it 'raises if there are too many arguments' do

      f = func('def f(a, b); end')

      lambda {
        c = f.new_context(nil, [ 1, 2, 3 ])
      }.should raise_error(ArgumentError)
    end

    it 'returns an empty new context when there are no call arguments' do

      f = func('def f; end')
      c = f.new_context(nil, [])

      c.variables.should == {}
    end

    it 'binds regular arguments' do

      f = func('def f(a, b); end')
      c = f.new_context(nil, [ 1, 2 ])

      c.variables.should == { :a => 1, :b => 2 }
    end

    it 'binds splat arguments' do

      f = func('def f(a, *b); end')
      c = f.new_context(nil, [ 1, 2, 3 ])

      c.variables.should == { :a => 1, :b => [ 2, 3 ] }
    end

    it 'binds splat arguments anyway' do

      f = func('def f(a, *b); end')
      c = f.new_context(nil, [ 1 ])

      c.variables.should == { :a => 1, :b => [] }
    end

    it 'binds splat arguments in the middle' do

      f = func('def f(a, *b, c); end')
      c = f.new_context(nil, [ 1, 2, 3, 4 ])

      c.variables.should == { :a => 1, :b => [ 2, 3 ], :c => 4 }
    end

    it 'binds optional arguments' do

      f = func('def f(a=:a); end')
      c = f.new_context(nil, [])

      c.variables.should == { :a => :a }
    end

    it 'binds optional and splat arguments' do

      f = func('def f(a, b=2, *c); end')
      c = f.new_context(nil, [ 1 ])

      c.variables.should == { :a => 1, :b => 2, :c => [] }
    end

    it 'binds the last hash' do

      f = func('def f(a, b); end')
      c = f.new_context(nil, [ 1,{ :c => 2 } ])

      c.variables.should == { :a => 1, :b => { :c => 2 } }
    end

    it 'binds blocks'
  end
end

