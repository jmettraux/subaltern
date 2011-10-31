
# subaltern

Subaltern is a Ruby self-interpreter. It's sub-functional, it's a subaltern.


## usage

    require 'subaltern'

    Subaltern.eval('1 + 1')
      # => 2

    c = Subaltern::Context.new('a' => 7)
    c.eval('a + 2')
      # => 9


## issues

https://github.com/jmettraux/subaltern/issues


## contact

IRC freenode.net #ruote


## license

MIT

