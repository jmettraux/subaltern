
require 'spec_helper'


describe Subaltern do

  context '#each' do

    describe 'break' do

      it 'works' do

        Subaltern.eval(%{
          [ 1, 2, 3 ].each do |i|
            break
          end
        }).should == nil
      end
    end

    describe 'break y' do

      it 'works' do

        Subaltern.eval(%{
          [ 1, 2, 3 ].each do |i|
            break i
          end
        }).should == 1
      end
    end

    describe 'next' do

      it 'works' do

        Subaltern.eval(%{
          a = []
          [ 1, 2, 3 ].each do |i|
            next
            a << i
          end
          a
        }).should == []
      end
    end
  end

  context '#collect' do

    describe 'next x' do

      it 'works' do

        Subaltern.eval(%{
          [ 1, 2, 3 ].collect do |i|
            next i * 3
          end
        }).should == [ 3, 6, 9 ]
      end

      it 'works with multiple values' do

        Subaltern.eval(%{
          [ 1, 2, 3 ].collect do |i|
            next i, i * 3
          end
        }).should == [ [ 1, 3 ], [ 2, 6 ], [ 3, 9 ] ]
      end
    end
  end
end

