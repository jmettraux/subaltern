
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

    it 'works' do

      Subaltern.eval(%{
        false or true
      }).should == true
    end

    it 'works (||)' do

      Subaltern.eval(%{
        false || true
      }).should == true
    end
  end

  describe 'and' do

    it 'works' do

      Subaltern.eval(%{
        true and true
      }).should == true
    end

    it 'works (&&)' do

      Subaltern.eval(%{
        true && true
      }).should == true
    end
  end
end
