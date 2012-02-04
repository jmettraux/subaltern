
# subaltern

Subaltern is a Ruby self-interpreter. It's sub-functional, it's a subaltern.

Meant to interpret sandboxed ruby code.


## usage

Innocent code:

    require 'subaltern'

    Subaltern.eval('1 + 1')
      # => 2

    c = Subaltern::Context.new('a' => 7)
    c.eval('a + 2')
      # => 9

Bad code:

    Subaltern.eval("''.eval('1 + 1')")
      # => raises a Subaltern::NonWhitelistedMethodError


## issues

https://github.com/jmettraux/subaltern/issues


## contact

IRC freenode.net #ruote


## license

MIT

