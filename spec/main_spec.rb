require_relative '../main.rb'

describe Enumerable do
  let(:test_array) { [20, 3, 12, 7, 15] }
  let(:string_array) { %w(cat, passion boolean possibility) }
  let(:test_range) { (1..9) }
  let(:test_hash) { { 'cat' => 'meow', 'dog' => 'bark' } }
  let(:test_block) { proc { |e| e.even? } }

  describe '#my_each' do
    context 'when called with a &block' do
      it 'returns an array when called on an array' do
        expect(test_array.my_each { }).to eq(test_array.each { })
      end

      it 'returns a range when called on a range' do
        expect(test_range.my_each { }).to eq(test_range.each { })
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_each.class).to eq(test_array.each.class)
      end

      it 'returns a range enumerator when called on a range' do
        expect(test_range.my_each.class).to eq(test_range.each.class)
      end
    end
  end

  describe '#my_each_with_index' do
    context 'when called with a &block' do
      it 'returns the original array when called on an array' do
        expect(test_array.my_each_with_index { }).to eql(test_array)
      end
      it 'returns the range itself when called on a range' do
        expect(test_range.my_each_with_index { }).to eql(test_range)
      end

      it 'returns the hash itself when called on a hash' do
        expect(test_hash.my_each_with_index { }).to eql(test_hash)
      end

      context 'returns the same result like #each_with_index' do
        it do
          original_each_test = test_array.each_with_index { |e, i| e + i }
          expect(test_array.my_each_with_index { |e, i| e + i }).to eql(original_each_test)
        end
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_each).to be_instance_of(Enumerator)
      end
      it 'returns a range enumerator when called on a range' do
        expect(test_range.my_each).to be_instance_of(Enumerator)
      end
    end
  end

  describe '#my_select' do
    context 'when called with a &block' do
      it 'returns an array of elements yield true when called on array' do
        test = test_array.select { |e| e > 3 }
        expect(test_array.my_select { |e| e > 3 }).to eq(test)
      end

      it 'returns an array of elements yield true when called on range' do
        test = test_range.select { |e| e > 5 }
        expect(test_range.my_select { |e| e > 5 }).to eq(test)
      end

      it 'not to be a nil when called on an empty array' do
        expect([].my_select { |e| e > 5 }).not_to be nil
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_select).to be_instance_of(Enumerator)
      end
    end
  end

  describe '#my_all?' do
    context 'when called with only an argument' do
      it 'returns true if the argument equals all the elements in the array else false' do
        expect(test_array.my_all?(Numeric)).to eql (test_array.all?(Numeric))
      end

      it 'returns true if the argument equals all the elements in the range else false' do
        expect(test_range.my_all?(3)).to eql(test_range.all?(3))
      end
    end

    context 'when called with only &block' do
      it 'returns true if all elements in the array yield true;' do
        expect(test_array.my_all? { test_block }).to eql(test_array.all? { test_block })
      end

      it 'returns true if all elements in the range yield true;' do
        expect(test_range.my_all? { test_block }).to eql(test_range.all? { test_block })
      end
    end

    context 'when called with no block and no argument' do
      it 'return true if all the element in the array are truthy else false' do
        expect(test_array.my_all?).to eql(test_array.all?)
      end

      it 'return true if all the element in the range are truthy else false' do
        expect(test_range.my_all?).to eql(test_range.all?)
      end

      it 'should not return false if called on an empty array' do
        expect([].my_all?).not_to be (false)
      end
    end

    context 'when called with a block and an argument' do
      it 'neglects the block and use the argument' do
        expect(test_array.my_all?(3) { test_block }).to eql(test_array.all?(3) { test_block })
      end
    end

    context 'when pattern/regex doesn\'t match' do
      it 'return false if every element in the array doesn\'t match with pattern ' do
        mixed_array = ['that', 'cat', 23, 'mat', true]
        expect(mixed_array.my_all?(/at/)).to eql(mixed_array.all?(/at/))
      end
    end
  end

  describe '#my_any?' do
  end
end
