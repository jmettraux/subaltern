
require 'spec_helper'


describe Subaltern do

  describe 'while' do

    it 'works' do

      Subaltern.eval(%{
        x = nil
        while true do
          x = :ok
          break
        end
        x
      }).should == :ok
    end

    it 'works as modifier' do

      Subaltern.eval(%{
        x = nil
        (x = :ok; break) while true
        x
      }).should == :ok
    end
  end

  describe 'until' do

    it 'works' do

      Subaltern.eval(%{
        x = nil
        until false do
          x = :ok
          break
        end
        x
      }).should == :ok
    end

    it 'works as modifier' do

      Subaltern.eval(%{
        x = nil
        (x = :ok; break) until false
        x
      }).should == :ok
    end
  end
end

