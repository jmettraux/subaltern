#--
# Copyright (c) 2011-2013, John Mettraux, jmettraux@gmail.com
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


module Subaltern

  #
  # Variable scope.
  #
  class Context

    attr_reader :parent

    # Create a new context
    #
    #   c = Subaltern.new
    #     # or
    #   c = Subaltern.new('var0' => 'value0', 'var1' => [ 1, 2, 3 ])
    #
    def initialize(parent={}, vars=nil)

      vars.merge!(Subaltern.core) if parent.nil?

      @parent, @variables = [ parent, vars ]
      @parent, @variables = [ nil, parent ] if vars.nil?
    end

    def [](key)

      return @variables[key] if @variables.has_key?(key)
      return @parent[key] if @parent

      raise UndefinedVariableError.new(key)
    end

    def []=(key, value)

      @variables[key] = value unless set(key, value)

      value
    end

    # Warning : shallow (doesn't lookup in parent context)
    #
    def has_key?(key)

      @variables.has_key?(key)
    end

    def lookup_block

      _, block =
        @variables.find { |k, v|
          v.is_a?(Block) && k.to_s.match(/^block-[\d\.]+$/)
        }

      return block if block
      return nil unless @parent
      @parent.lookup_block
    end

    # Eval a piece of Ruby code within this context.
    #
    def eval(source_or_tree)

      tree =
        if source_or_tree.is_a?(String)
          Parser::CurrentRuby.parse(source_or_tree)
        else
          source_or_tree
        end

      begin
        Subaltern.eval_tree(self, tree)
      rescue Return => r
        r.value
      end
    end

    # Unlike #[] doesn't raise UndefinedVariableError.
    #
    def lookup(key)

      return @variables[key] if @variables.has_key?(key)
      return @parent.lookup(key) if @parent

      nil
    end

    protected

    def set(key, value)

      if has_key?(key)
        @variables[key] = value
        true
      elsif @parent == nil
        false
      else
        @parent.set(key, value)
      end
    end
  end
end

