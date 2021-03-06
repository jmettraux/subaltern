
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

  describe 'for x in xs' do

    it 'works' do

      Subaltern.eval(%{
        a = []
        for e in [ 1, 2, 3, 4 ]
          a << e
        end
        a
      }).should == [ 1, 2, 3, 4 ]
    end

    it 'does not create a new context' do

      Subaltern.eval(%{
        for i in [ 1 ]
          a = i
        end
        a
      }).should == 1
    end
  end

  describe 'for k,v in h' do

    it 'works' do

      Subaltern.eval(%{
        a = []
        for k, v in { 'a' => 'b', 'c' => 'd' }
          a << k + ':' + v
        end
        a
      }).sort.should == %w[ a:b c:d ]
    end
  end

  describe 'loop' do

    it 'works' do

      Subaltern.eval(%{
        a = 0
        loop do
          a = a + 1
          break if a > 7
        end
        a
      }).should == 8
    end
  end
end

