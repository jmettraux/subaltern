
require 'spec_helper'


describe Subaltern do

  describe 'true' do

    it 'is returned as is' do

      Subaltern.eval(%{
        true
      }).should == true
    end
  end

  describe 'false' do

    it 'is returned as is' do

      Subaltern.eval(%{
        false
      }).should == false
    end
  end

  describe 'not' do

    it 'works' do

      Subaltern.eval(%{
        not true
      }).should == false
    end

    it 'works (!)' do

      Subaltern.eval(%{
        ! true
      }).should == false
    end

    it 'works (!!)' do

      Subaltern.eval(%{
        !! "nada"
      }).should == true
    end
  end

  describe 'or' do

    it 'works (false or true)' do

      Subaltern.eval(%{
        false or true
      }).should == true
    end

    it 'works (false or false)' do

      Subaltern.eval(%{
        false or false
      }).should == false
    end

    it 'works (false || true)' do

      Subaltern.eval(%{
        false || true
      }).should == true
    end

    it 'works (false || false)' do

      Subaltern.eval(%{
        false || false
      }).should == false
    end
  end

  describe 'and' do

    it 'works (true and true)' do

      Subaltern.eval(%{
        true and true
      }).should == true
    end

    it 'works (true and false)' do

      Subaltern.eval(%{
        true and false
      }).should == false
    end

    it 'works (true && true)' do

      Subaltern.eval(%{
        true && true
      }).should == true
    end

    it 'works (true && false)' do

      Subaltern.eval(%{
        true && false
      }).should == false
    end
  end

  describe '==' do

    it 'works' do

      Subaltern.eval(%{
        1 == 1
      }).should == true
    end

    it 'works (2)' do

      Subaltern.eval(%{
        1 == 2
      }).should == false
    end
  end

  describe '!=' do

    it 'works' do

      Subaltern.eval(%{
        1 != 1
      }).should == false
    end

    it 'works (2)' do

      Subaltern.eval(%{
        1 != 2
      }).should == true
    end
  end

  describe '==' do

    it 'returns true or false' do

      Subaltern.eval(%{
        [ true == false, true == true, false == true, false == false ]
      }).should == [ false, true, false, true ]
    end
  end

  describe '===' do

    it 'works' do

      Subaltern.eval(%{
        String === ''
      }).should == true
    end
  end
end

