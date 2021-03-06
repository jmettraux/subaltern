
require 'spec_helper'


describe Subaltern do

  context Hash do

    describe '{}' do

      it 'returns the hash' do

        Subaltern.eval('{}').should == {}
        Subaltern.eval('{ 1 => 2, 3 => 4 }').should == { 1 => 2, 3 => 4 }
      end
    end

    describe '#[]' do

      it 'works' do

        Subaltern.eval('{}["a"]').should == nil
        Subaltern.eval('{ "a" => 1 }["a"]').should == 1
      end
    end

    describe '.{key} (javascripty)' do

      it 'works' do

        Subaltern.eval('{ "a" => 1 }.a').should == 1
        Subaltern.eval('{ "length" => "zero" }.length').should == 1
      end
    end

    describe '#each' do

      it 'works' do

        Subaltern.eval('''
          s = []
          { "a" => 1, "b" => 2 }.each { |k, v| s << "#{k}:#{v}" }
          s.sort.join(", ")
        ''').should == 'a:1, b:2'
      end
    end

    describe '#collect' do

      it 'works' do

        Subaltern.eval('''
          { "a" => 1, "b" => 2 }.collect do |k, v| "#{k}:#{v}"; end.sort.join(", ")
        ''').should == 'a:1, b:2'
      end
    end

    describe '#inject' do

      it 'works' do

        Subaltern.eval(%{
          { "a" => 1, "b" => 2 }.inject(0) { |sum, (k, v)| sum + v }
        }).should == 3
      end
    end

    describe '#select' do

      it 'works' do

        if ruby19?

          Subaltern.eval('''
            { "a" => 1, "b" => 2, "c" => 3 }.select { |k, v| v.odd? }
          ''').should == { 'a' => 1, 'c' => 3 }

        else

          Subaltern.eval('''
            { "a" => 1, "b" => 2, "c" => 3 }.select { |k, v| v.odd? }
          ''').sort_by { |e| e.first }.should == [ [ 'a', 1 ], [ 'c', 3 ] ]
        end
      end
    end
  end
end

