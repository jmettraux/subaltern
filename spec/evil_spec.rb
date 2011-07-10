
require 'spec_helper'


class String
  def constantize
    eval(self)
  end
end

describe Subaltern do

  #describe '__FILE__' do
  #  it 'raises an error' do
  #    p Subaltern.eval('__FILE__')
  #  end
  #end

  describe "''.eval('1 + 1')" do

    it 'raises' do

      lambda {
        Subaltern.eval("''.eval('1 + 1')")
      }.should raise_error(Subaltern::NonWhitelistedMethodError)
    end
  end

  describe 'calls on non-whitelisted classes' do

    it 'raises' do

      lambda {
        Subaltern.eval("'File'.constantize.read('#{__FILE__}')")
      #}.should raise_error(Subaltern::NonWhitelistedClassError)
      }.should raise_error(Subaltern::NonWhitelistedMethodError)
    end
  end

  describe 'a constant lookup' do

    it 'raises' do

      lambda {
        Subaltern.eval('ENV')
      }.should raise_error(Subaltern::AccessError)
    end

    it 'raises' do

      lambda {
        Subaltern.eval('File::Utils')
      }.should raise_error(Subaltern::AccessError)
    end
  end

  describe 'a call on a constant' do

    it 'raises' do

      lambda {
        Subaltern.eval('ENV["HOME"]')
      }.should raise_error(Subaltern::AccessError)
    end
  end

  describe 'a global variable lookup' do

    it 'raises' do

      lambda {
        Subaltern.eval('$nada')
      }.should raise_error(Subaltern::AccessError)
    end
  end

  describe 'backquoting' do

    it 'raises' do

      lambda {
        Subaltern.eval('`ls -al`')
      }.should raise_error(Subaltern::AccessError)
    end
  end
end

