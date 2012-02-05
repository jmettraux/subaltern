#--
# Copyright (c) 2011-2012, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++

require 'ruby_parser'

require 'subaltern/version'
require 'subaltern/errors'
require 'subaltern/context'
require 'subaltern/evaluator'
require 'subaltern/kernel'


module Subaltern

  def self.eval(source, vars={})

    Context.new(nil, vars).eval(source)
  end

  def self.add_methods(object, source)

    tree = RubyParser.new.parse(source).to_a

    methods = tree[0] == :block ? tree[1..-1] : [ tree ]

    methods.each do |_, name, args, body|

      args = args[1..-1]

      vars = '{ ' + args.map { |arg| "'#{arg}' => #{arg}" }.join(', ') + ' }'

      object.instance_eval(%{

        def #{name}(#{args.map(&:to_s).join(', ')})
          Subaltern.eval_tree(Context.new(nil, #{vars}), #{body.inspect})
        end
      })
    end
  end
end

