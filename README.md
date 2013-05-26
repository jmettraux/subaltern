
# subaltern

[![Build Status](https://secure.travis-ci.org/jmettraux/subaltern.png)](http://travis-ci.org/jmettraux/subaltern)

Subaltern is a Ruby self-interpreter. It's sub-functional, it's a subaltern.

Meant to interpret sandboxed ruby code.

Works with ruby >= 1.9 (TODO: check if with "parser" this still holds).


## usage

### Subaltern.eval

Innocent code:

```ruby
  require 'subaltern'

  Subaltern.eval('1 + 1')
    # => 2

  c = Subaltern::Context.new('a' => 7)
  c.eval('a + 2')
    # => 9
```

Bad code:

```ruby
  Subaltern.eval("''.eval('1 + 1')")
    # => raises a Subaltern::NonWhitelistedMethodError
```

### Subaltern.add_methods

TODO


## issues

https://github.com/jmettraux/subaltern/issues


## contact

IRC freenode.net #ruote


## license

MIT

