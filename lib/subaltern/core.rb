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

  def self.core

    #{
    #  'loop' => LoopFunction.new
    #}
    {}
  end

#  class LoopFunction < Function
#
#    def initialize
#    end
#
#    def call(context, tree)
#
#      return nil unless context['__block']
#        # a real Ruby would return an Enumerator instance
#
#      con = Context.new(context, {})
#
#      loop do
#
#        begin
#
#          r = context['__block'].call(con, [], false)
#            # new_context is false
#
#        rescue Command => c
#
#          case c.name
#            when 'break' then break c
#            when 'next' then next c
#            else raise c
#          end
#        end
#      end
#    end
#  end
end

