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

  #--
  # whitelisting, and some blacklisting, out of pure distrust
  #++

  BLACKLIST = %w[
extend instance_eval instance_exec method methods include
private_methods public_methods protected_methods singleton_methods
send __send__
taint tainted? untaint
instance_variables instance_variable_get instance_variable_set
instance_variable_defined?
free frozen?
  ]

  # TODO :
  #
  # eventually generate those whitelists by doing
  #
  #   class.public_instance_methods - BLACKLIST
  #
  # though it would accept any new methods added by the 'user'.
  # Well, since the 'user' can't overwrite methods...

  WHITELIST = {
    Array => %w[
& * + - << <=> == === =~ [] []=
all? any? assoc at choice class clear clone collect collect! combination
compact compact! concat count cycle delete delete_at delete_if detect display
drop drop_while dup each each_cons each_index each_slice each_with_index
empty? entries enum_cons enum_for enum_slice enum_with_index eql? equal?
fetch fill find find_all find_index first flatten flatten!
grep group_by hash id include? index indexes indices inject insert inspect
instance_of? is_a? join kind_of? last length map map! max max_by member?
min min_by minmax minmax_by nil? nitems none? object_id one? pack partition
permutation pop product push rassoc reduce reject reject! replace respond_to?
reverse reverse! reverse_each rindex select shift shuffle shuffle! size
slice slice! sort sort! sort_by take take_while tap to_a to_ary to_enum to_s
transpose type uniq uniq!  unshift untaint values_at zip |
    ],
    Fixnum => %w[
% & * ** + +@ - -@ / < << <= <=> == === =~ > >= >> [] ^ __id__
abs between? ceil chr class clone coerce display div divmod downto dup enum_for
eql? equal? even? fdiv floor hash id id2name inspect
instance_of? integer? is_a? kind_of? modulo next nil? nonzero? object_id odd?
ord prec prec_f prec_i pred quo remainder respond_to? round size step succ tap
times to_a to_enum to_f to_i to_int to_s to_sym truncate type upto zero? | ~
!=
    ],
    Hash => %w[
== === =~ [] []= __id__
all? any? class clear clone collect count cycle default default= default_proc
delete delete_if detect display drop drop_while dup each each_cons each_key
each_pair each_slice each_value each_with_index empty? entries enum_cons
enum_for enum_slice enum_with_index eql? equal? fetch find find_all find_index
first grep group_by has_key? has_value? hash id include? index indexes indices
inject inspect instance_of? invert is_a? key? keys kind_of? length map max
max_by member? merge merge! min min_by minmax minmax_by nil? none? object_id
one? partition reduce rehash reject reject! replace respond_to? reverse_each
select shift size sort sort_by store take take_while tap to_a to_enum to_hash
to_s type update value? values values_at zip
    ],
    MatchData => %[
[]
    ],
    NilClass => %[
& == === =~ ^ __id__ class clone display dup enum_for eql? equal? hash
id inspect instance_of? is_a? kind_of? nil? object_id respond_to?
tap to_a to_enum to_f to_i to_s type |
    ],
    Regexp => %w[
match
    ],
    String => %w[
% * + < << <= <=> == === =~ > >= [] []= __id__
all? any? between? bytes bytesize capitalize capitalize! casecmp center chars
chomp chomp! chop chop! class clone collect concat count crypt cycle delete
delete! detect display downcase downcase! drop drop_while dump dup
each each_byte each_char each_cons each_line each_slice each_with_index empty?
end_with? entries enum_cons enum_for enum_slice enum_with_index eql? equal?
find find_all find_index first grep group_by gsub gsub! hash hex id include?
index inject insert inspect instance_of? intern is_a? kind_of? length lines
ljust lstrip lstrip! map match max max_by member? min min_by minmax minmax_by
next next! nil? none? object_id oct one? partition reduce reject replace
respond_to? reverse reverse! reverse_each rindex rjust rpartition rstrip
rstrip! scan select size slice slice! sort sort_by split squeeze squeeze!
start_with? strip strip! sub sub! succ succ! sum swapcase swapcase! take
take_while tap to_a to_enum to_f to_i to_s to_str to_sym tr tr! tr_s tr_s!
type unpack upcase upcase! upto zip !
    ],
    Class => %w[
===
    ],
    TrueClass => %w[
== !
    ],
    FalseClass => %w[
== !
    ],
  }

  WHITELISTED_CONSTANTS =
    WHITELIST.keys.collect { |k| k.to_s } +
    %w[ FalseClass TrueClass ]

  #--
  # helper classes
  #++

  #
  # I wish I could use throw/catch, but only Ruby 1.9.x allows for throwing
  # something else than a Symbol.
  # Going with a standard error for now.
  #
  class Return < StandardError

    attr_reader :value

    def initialize(value)

      @value = value
      super('')
    end
  end

  #
  # A command like 'break' or 'next'.
  #
  class Command < StandardError

    attr_reader :name, :args

    def initialize(name, args)
      @name = name
      @args = args
    end

    # Used by Command.narrow
    #
    def result

      return nil if args.empty?
      return @args.first if args.size == 1
      @args
    end

    # Used to circumvent a difference between ruby 1.8 and 1.9...
    #
    def self.narrow(o)

      return o.result if o.is_a?(Command)
      return o.collect { |e| e.is_a?(Command) ? e.result : e } if o.is_a?(Array)
      o
    end
  end

  #
  # Wrapper for function trees when stored in Context instances.
  #
  class Function

    def initialize(tree)

      @tree = tree

      prepare_args(tree.children[1].children)
    end

    def prepare_args(arg_tree)

      @args = []
      @optargs = {}

      arg_tree.each do |t|
        @args << [ t.type, t.children.first ]
        @optargs[t.children.first] = t.children.last if t.type == :optarg
      end
    end

    def new_context(parent_context, call_args)

      con = Context.new(parent_context, {})

      if
        call_args.length > @args.length &&
        ! @args.find { |a| a[0] == :restarg }
      then
        raise ArgumentError.new(
          "wrong number of arguments (#{call_args.length} for #{@args.length})")
      end

      args = @args.dup
      cargs = call_args.dup
      first, shift = :first, :shift

      loop do

        break if args.empty?

        type, name = args.send(first)

        if type == :restarg
          if first == :first
            first, shift = :last, :pop
          else
            con[name] = cargs
            break
          end
        else
          args.send(shift)
          con[name] =
            if type == :blockarg
              parent_context['block']
            elsif type == :optarg && cargs.empty?
              Subaltern.eval_tree(parent_context, @optargs[name])
            else
              cargs.send(shift)
            end
        end
      end

      con
    end

    def call(context, args)

      begin
        do_call(context, args)
      rescue Return => r
        r.value
      end
    end

    def do_call(context, args)

      Subaltern.eval_tree(
        new_context(context, args),
        @tree.children.last)
    end
  end

  class Block < Function

    def initialize(context, tree)

      super(tree)
      @context = context
    end

    def call(*args)

      do_call(@context, args)
    end
  end

  # Will raise an exception if calling that method on this target
  # is not whitelisted (or is blacklisted).
  #
  def self.bounce(target, method)

    return if target.is_a?(Subaltern::Block) && method == :call

    if BLACKLIST.include?(method.to_s)
      raise BlacklistedMethodError.new(target.class)
    end
    unless WHITELIST.keys.include?(target.class)
      raise NonWhitelistedClassError.new(target.class)
    end
    unless WHITELIST[target.class].include?(method.to_s)
      raise NonWhitelistedMethodError.new(target.class, method)
    end
  end

  #--
  # the eval_ methods
  #++

  # The entry point.
  #
  def self.eval_tree(context, tree)

    send("eval_#{tree.type}", context, tree)

  rescue NoMethodError => nme
    puts '-' * 80
    p nme
    pp tree
    puts nme.backtrace[0, 7].join("\n")
    puts '...'
    puts '-' * 80
    raise nme
  end

  def self.eval_begin(context, tree)

    tree.children.inject(nil) { |result, t| eval_tree(context, t) }
  end

  def self.eval_def(context, tree)

    context[tree.children.first] = Function.new(tree)

    nil
  end

  def self.atom(context, tree)

    tree.children.first
  end

  def self.boolean(context, tree)

    tree.type == :true
  end

  self.instance_eval do

    alias eval_int atom
    alias eval_str atom
    alias eval_float atom
    alias eval_sym atom

    alias eval_true boolean
    alias eval_false boolean
  end

  def self.eval_nil(context, tree)

    nil
  end

#  def self.eval_call(context, tree)
#
#    if tree[1] == nil
#      # variable lookup or function application...
#
#      value = eval_lvar(context, tree[1, 2])
#
#      return value.call(context, tree) if value.is_a?(Subaltern::Function)
#      return value
#    end
#
#    target = eval_tree(context, tree[1])
#    method = tree[2].to_s
#    args = tree[3..-1]
#
#    if is_javascripty_hash_lookup?(target, method, args)
#      return target[method]
#    end
#
#    args = args.collect { |t| eval_tree(context, t) }
#
#    return target.call(context, args) if target.is_a?(Subaltern::Block)
#
#    bounce(target, method)
#
#    target.send(method, *args)
#  end
#
#  def self.is_javascripty_hash_lookup?(target, method, args)
#
#    target.is_a?(Hash) &&
#    args.empty? &&
#    ( ! WHITELIST[Hash].include?(method)) &&
#    target.has_key?(method)
#  end

  def self.eval_send(context, tree)

    funcname = tree.children[1]

    args = tree.children[2..-1]
    args = args.collect { |a| eval_tree(context, a) } if args

    if tree.children.first
      #
      # method call

      target = eval_tree(context, tree.children.first)

      bounce(target, funcname)

      target.send(funcname.to_s, *args)

    else
      #
      # no target, var lookup or function call

      func = context[funcname]

      if func.is_a?(Function)

        func.call(context, args)

      elsif args.empty?
        #
        # "parser" just says (send nil :a) for both "a()" and "a"...

        func

      else

        raise UndefinedMethodError.new("'#{funcname}' is not a function")
      end
    end
  end

  def self.eval_irange(context, tree)

    a = eval_tree(context, tree.children[0])
    b = eval_tree(context, tree.children[1])

    a..b
  end

  def self.eval_lvasgn(context, tree)

    context[tree.children.first] = eval_tree(context, tree.children.last)
  end

  def self.eval_lvar(context, tree)

    context[tree.children.first]
  end

  def self.eval_regexp(context, tree)

    str = tree.children.first.children.first

    opts = tree.children.last.children
    options = 0
    options |= Regexp::EXTENDED if opts.include?(:x)
    options |= Regexp::MULTILINE if opts.include?(:m)
    options |= Regexp::IGNORECASE if opts.include?(:i)

    Regexp.new(str, options)
  end

  def self.eval_return(context, tree)

    raise(Return.new(eval_tree(context, tree.children.first)))
  end

  def self.eval_array(context, tree)

    tree.children.collect { |t| eval_tree(context, t) }
  end

  def self.eval_hash(context, tree)

    tree.children.inject({}) { |h, t|
      h[eval_tree(context, t.children.first)] =
        eval_tree(context, t.children.last)
      h
    }
  end

  def self.eval_dstr(context, tree)

    tree.children.collect { |t| eval_tree(context, t) }.join
  end

  def self.eval_or(context, tree)

    tree.children.each do |t|
      if r = eval_tree(context, t); return true; end
    end

    false
  end

  def self.eval_and(context, tree)

    tree.children.each do |t|
      unless r = eval_tree(context, t); return false; end
    end

    true
  end

  def self.eval_const(context, tree)

    parent = Kernel
    parent = eval_tree(context, tree.children.first) if tree.children.first

    const = parent.const_get(tree.children.last)

    return const if WHITELISTED_CONSTANTS.include?(const.to_s)

    raise AccessError.new("no access to constant (#{const.to_s})")
  end

  def self.eval_block(context, tree)

    con = Context.new(context, 'block' => Block.new(context, tree))

    eval_tree(con, tree.children.first)

#    # NB:
#    #
#    # $ bx ruby-parse -e "[].each(&block)"
#    # (send
#    #   (array) :each
#    #   (block-pass
#    #     (send nil :block)))
#    #
#    # $ bx ruby-parse -e "func { 1 }"
#    # (block
#    #   (send nil :func)
#    #   (args)
#    #   (int 1))
#
#    t = tree.children.first
#    c = t.children.dup
#    c << AST::Node.new(:blockarg, [ :block ])
#    t = AST::Node.new(t.type, c)
#    p t
#
#    eval_tree(con, t)
  end

  def self.eval_blockarg(context, tree)

    nil
  end

  def self.eval_yield(context, tree)

    block = context['block']

    return LocalJumpError.new('no block given (yield)') unless block

    args = tree.children.collect { |t| eval_tree(context, t) }

    block.do_call(context, args)
  end

#  def self.eval_evstr(context, tree)
#
#    eval_tree(context, tree[1])
#  end
#
#  def self.eval_xstr(context, tree)
#
#    raise AccessError.new("no backquoting allowed (#{tree[1]})")
#  end
#
#  def self.eval_dxstr(context, tree)
#
#    raise AccessError.new("no backquoting allowed (#{tree[1]})")
#  end
#
#  def self.eval_gvar(context, tree)
#
#    raise AccessError.new("no global variables (#{tree[1]})")
#  end
#
#  def self.eval_colon2(context, tree)
#
#    raise AccessError.new("no access to constants (#{tree[1]})")
#  end
#
#  def self.eval_iter(context, tree)
#
#    if tree[1][1] == nil
#      #
#      # function with a block
#
#      con = Context.new(context, '__block' => Block.new(tree[2..-1]))
#
#      eval_call(con, tree[1])
#
#    else
#      #
#      # method with a block
#
#      target = eval_tree(context, tree[1][1])
#      method = tree[1][2]
#
#      bounce(target, method)
#
#      method_args = tree[1][3..-1].collect { |t| eval_tree(context, t) }
#      block = Block.new(tree[2..-1])
#
#      command = nil
#
#      result = target.send(method, *method_args) { |*args|
#        begin
#          block.call(context, args)
#        rescue Command => c
#          case c.name
#            when 'break' then break c
#            when 'next' then next c
#            else raise c
#          end
#        end
#      }
#
#      Command.narrow(result)
#    end
#  end
#
#  def self.eval_break(context, tree)
#
#    raise(
#      Command.new('break', tree[1..-1].collect { |t| eval_tree(context, t) }))
#  end
#
#  def self.eval_next(context, tree)
#
#    raise(
#      Command.new('next', tree[1..-1].collect { |t| eval_tree(context, t) }))
#  end
#
#  def self.eval_if(context, tree)
#
#    if eval_tree(context, tree[1])
#      eval_tree(context, tree[2])
#    elsif tree[3]
#      eval_tree(context, tree[3])
#    end
#  end
#
#  def self.eval_case(context, tree)
#
#    value = eval_tree(context, tree[1])
#    whens = tree[2..-1].select { |t| t[0] == :when }
#    the_else = (tree[2..-1] - whens).first
#
#    whens.each do |w|
#
#      eval_tree(context, w[1]).each do |v|
#
#        return eval_tree(context, w[2]) if v === value
#      end
#    end
#
#    the_else ? eval_tree(context, the_else) : nil
#  end
#
#  def self.eval_while(context, tree)
#
#    result = while eval_tree(context, tree[1])
#
#      begin
#        eval_tree(context, tree[2])
#      rescue Command => c
#        case c.name
#          when 'break' then break c
#          when 'next' then next c
#          else raise c
#        end
#      end
#    end
#
#    Command.narrow(result)
#  end
#
#  def self.eval_until(context, tree)
#
#    result = until eval_tree(context, tree[1])
#
#      begin
#        eval_tree(context, tree[2])
#      rescue Command => c
#        case c.name
#          when 'break' then break *c.args
#          when 'next' then next *c.args
#          else raise c
#        end
#      end
#    end
#
#    Command.narrow(result)
#  end
#
#  def self.eval_for(context, tree)
#
#    values = eval_tree(context, tree[1])
#    block = Block.new(tree[2..-1])
#
#    values.each { |v| block.call(context, [ v ], false) }
#  end
#
#  def self.eval_rescue(context, tree)
#
#    Subaltern.eval_tree(context, tree[2][2])
#  end
end

