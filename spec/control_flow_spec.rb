
require 'spec_helper'


describe Subaltern do

  describe 'if' do

    it 'works (then)' do

      Subaltern.eval(%{
        if true
          :ok
        end
      }).should == :ok
    end

    it 'works (complex expression)' do

      Subaltern.eval(%{
        if false or true
          :ok
        end
      }).should == :ok
    end

    it 'works (else)' do

      Subaltern.eval(%{
        if false
          :not_ok
        else
          :ok
        end
      }).should == :ok
    end

    it 'works postfix' do

      Subaltern.eval(%{
        'ok' if true
      }).should == 'ok'
    end
  end

  describe 'elsif' do

    it 'works' do

      Subaltern.eval(%{
        if false
          :not_ok
        elsif true
          :ok
        else
          :really_not_ok
        end
      }).should == :ok
    end
  end

  describe 'unless' do

    it 'works' do

      Subaltern.eval(%{
        unless false
          :ok
        else
          :not_ok
        end
      }).should == :ok
    end
  end

  describe 'case' do

    it 'works' do

      Subaltern.eval(%{
        case true
          when true then :ok
          when false then :not_ok
          else :really_not_ok
        end
      }).should == :ok
    end

    it 'works (else)' do

      Subaltern.eval(%{
        case false
          when true then :not_ok
          else :ok
        end
      }).should == :ok
    end

    it 'works (multiline)' do

      Subaltern.eval(%{
        case true
          when true
            :not_ok
            :ok
          else
            :really_not_ok
        end
      }).should == :ok
    end

    it 'works (classes)' do

      Subaltern.eval(%{
        case true
          when FalseClass
            :not_ok
          when TrueClass
            :ok
          else
            :really_not_ok
        end
      }).should == :ok
    end

    it 'works (regexes)' do

      Subaltern.eval(%{
        case 'the little bird'
          when /fox/
            :not_ok
          when /bird/
            :ok
          else
            :really_not_ok
        end
      }).should == :ok
    end

    it 'works (regexes 2)' do

      Subaltern.eval(%{
        case 'the little bird'
          when /squirrel/
            :not_ok
          when /chipmunk/
            :really_not_ok
          else
            :ok
        end
      }).should == :ok
    end
  end

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

  describe '#?' do

    it 'works' do

      Subaltern.eval(%{
        true ? 1 : 0
      }).should == 1
    end

    it 'works (then)' do

      Subaltern.eval(%{
        false ? 0 : 1
      }).should == 1
    end
  end
end

