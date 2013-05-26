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

  class SubalternError < RuntimeError
  end

  class BlacklistedMethodError < SubalternError

    attr_reader :klass, :method

    def initialize(klass, meth)

      @klass = klass
      @method = meth
      super("blacklisted : #meth (in this case : #{klass.inspect})")
    end
  end

  class NonWhitelistedClassError < SubalternError

    attr_reader :klass

    def initialize(klass)

      @klass = klass
      super("not whitelisted : #{klass.inspect}")
    end
  end

  class NonWhitelistedMethodError < SubalternError

    attr_reader :klass, :method

    def initialize(klass, meth)

      @klass = klass
      @method = meth
      super("not whitelisted : #{klass.inspect}##{meth}")
    end
  end

  class UndefinedVariableError < SubalternError

    attr_reader :variable_name

    def initialize(varname)

      @variable_name = varname
      super("undefined variable #{varname.inspect}")
    end
  end

  class UndefinedMethodError < SubalternError
  end

  class AccessError < SubalternError
  end
end

