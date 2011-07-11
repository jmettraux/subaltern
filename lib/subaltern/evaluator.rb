#--
# Copyright (c) 2011-2011, John Mettraux, jmettraux@gmail.com
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
type unpack upcase upcase! upto zip
    ]
  }

  #--
  # helper classes
  #++

  #
  # Variable scope.
  #
  class Context

    attr_reader :parent

    def initialize(parent, vars)

      @parent = parent
      @variables = vars
    end

    def [](key)

      return @variables[key] if @variables.has_key?(key)
      return @parent[key] if @parent

      raise UndefinedVariableError.new(key)
    end

    def []=(key, value)

      @variables[key] = value
    end
  end

  #
  # Wrapper for function trees when stored in Context instances.
  #
  class Function

    def initialize(tree)

      @tree = tree
    end

    def call(context, tree)

      args = tree[3][1..-1].collect { |t| Subaltern.eval_tree(context, t) }

      c = Context.new(context, {})
      args.each_with_index { |arg, i| c[@tree[2][1..-1][i].to_s] = arg }

      Subaltern.eval_tree(c, @tree[3])
    end
  end

  #--
  # the eval_ methods
  #++

  # The entry point.
  #
  def self.eval_tree(context, tree)

    send("eval_#{tree.first}", context, tree)

  rescue NoMethodError => nme
    puts '-' * 80
    p nme
    p tree
    puts nme.backtrace.join("\n")
    puts '-' * 80
  end

  %w[ false true nil ].each do |key|
    instance_eval %{ def eval_#{key}(context, tree); #{key}; end }
  end

  def self.eval_lit(context, tree)

    tree[1]
  end

  def self.eval_str(context, tree)

    tree[1]
  end

  def self.eval_dstr(context, tree)

    tree[1..-1].collect { |t|
      t.is_a?(String) ? t : eval_tree(context, t)
    }.join
  end

  def self.eval_evstr(context, tree)

    eval_tree(context, tree[1])
  end

  def self.eval_xstr(context, tree)

    raise AccessError.new("no backquoting allowed (#{tree[1]})")
  end

  def self.eval_array(context, tree)

    tree[1..-1].collect { |t| eval_tree(context, t) }
  end

  def self.eval_hash(context, tree)

    Hash[*eval_array(context, tree)]
  end

  def self.is_javascripty_hash_lookup?(target, method, args)

    target.is_a?(Hash) &&
    args.empty? &&
    ( ! WHITELIST[Hash].include?(method)) &&
    target.has_key?(method)
  end

  def self.eval_call(context, tree)

    if tree[1] == nil
      # variable lookup or function application...

      value = eval_lvar(context, tree[1, 2])

      return value.call(context, tree) if value.is_a?(Subaltern::Function)
      return value
    end

    target = eval_tree(context, tree[1])
    method = tree[2].to_s
    args = tree[3][1..-1]

    if is_javascripty_hash_lookup?(target, method, args)
      return target[method]
    end

    if BLACKLIST.include?(method.to_s)
      raise BlacklistedMethodError.new(target.class)
    end
    unless WHITELIST.keys.include?(target.class)
      raise NonWhitelistedClassError.new(target.class)
    end
    unless WHITELIST[target.class].include?(method)
      raise NonWhitelistedMethodError.new(target.class, method)
    end

    args = args.collect { |t| eval_tree(context, t) }

    target.send(method, *args)
  end

  def self.eval_block(context, tree)

    tree[1..-1].collect { |t| eval_tree(context, t) }.last
  end

  def self.eval_lasgn(context, tree)

    context[tree[1].to_s] = eval_tree(context, tree[2])
  end

  def self.eval_lvar(context, tree)

    context[tree[1].to_s]
  end

  def self.eval_gvar(context, tree)

    raise AccessError.new("no global variables (#{tree[1]})")
  end

  def self.eval_const(context, tree)

    raise AccessError.new("no access to constants (#{tree[1]})")
  end

  def self.eval_colon2(context, tree)

    raise AccessError.new("no access to constants (#{tree[1]})")
  end

  def self.eval_defn(context, tree)

    name = tree[1].to_s
    context[name] = Function.new(tree)

    nil
  end

  def self.eval_scope(context, tree)

    eval_tree(context, tree[1])
  end

  def self.eval_iter(context, tree)

    p tree
    nil
  end
end

