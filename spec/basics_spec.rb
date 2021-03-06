
require 'spec_helper'


describe Subaltern do

  describe 'bad syntax' do

    it 'raises a Racc::ParseError' do

      lambda {
        #Subaltern.eval('adsfad:12')
        Subaltern.eval('def nada')
      }.should raise_error(Parser::SyntaxError)
    end
  end

  describe 'a literal, a string, or a boolean' do

    it 'is returned as is' do

      [
        1, 'hello', 1.0, true, false, :a, nil
      ].each do |lit|
        Subaltern.eval(lit.inspect).should == lit
      end
    end
  end

  describe 'ranges' do

    it 'is returned as is' do

      Subaltern.eval(%{
        1..5
      }).should == (1..5)
    end
  end

  describe 'a sequence of code' do

    it 'is executed line by line' do

      Subaltern.eval(%{
        1
        2
      }).should == 2
    end

    it 'is executed line by line' do

      Subaltern.eval(%{
        1; 2
      }).should == 2
    end
  end

  describe 'variable lookup' do

    it 'works' do

      Subaltern.eval('a', { :a => 1 }).should == 1
    end
  end

  describe 'variable assignment' do

    it 'works' do

      Subaltern.eval(%{
        a = 2; a
      }).should == 2
    end
  end

  describe 'using regular expressions' do

    it 'works' do

      Subaltern.eval(%{
        /abc/.match('d')
      }).should == nil

      Subaltern.eval(%{
        /abc/.match('myabcde')
      }).class.should == MatchData

      Subaltern.eval(%{
        /(abc)/.match('abc')[1]
      }).should == 'abc'

      Subaltern.eval(%{
        /abc/im.match('ABC')[0]
      }).should == 'ABC'
    end
  end

  describe 'return' do

    it 'is honored' do

      Subaltern.eval(%{
        'a'
        return 'A'
        'b'
      }).should == 'A'
    end
  end

  describe 'unary -' do

    it 'works' do

      Subaltern.eval(%{
        [ 1 + -5, - 5 ]
      }).should == [ -4, -5 ]
    end
  end

  describe 'brackets (' do

    it 'works' do

      Subaltern.eval(%{
        (1 + 2) * 3
      }).should == 9
    end
  end
end

