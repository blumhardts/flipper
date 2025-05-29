RSpec.describe Flipper::UI::Configuration::ExpressionProperties do
  describe '.validate_property' do
    it 'accepts valid property definition with symbol type' do
      expect {
        described_class.validate_property('user_id', type: 'string')
      }.not_to raise_error
    end

    it 'accepts valid property definition with string type' do
      expect {
        described_class.validate_property('user_id', 'type' => 'string')
      }.not_to raise_error
    end

    it 'raises error when definition is not a hash' do
      expect {
        described_class.validate_property('user_id', 'string')
      }.to raise_error(ArgumentError, "Property definition for 'user_id' must be a hash")
    end

    it 'raises error when type is missing' do
      expect {
        described_class.validate_property('user_id', {})
      }.to raise_error(ArgumentError, "Property 'user_id' must specify a type")
    end

    it 'raises error for unsupported type' do
      expect {
        described_class.validate_property('user_id', type: 'array')
      }.to raise_error(ArgumentError, "Property 'user_id' has unsupported type 'array'. Supported types: boolean, string, number")
    end

    it 'accepts all supported types' do
      %w(boolean string number).each do |type|
        expect {
          described_class.validate_property('test_prop', type: type)
        }.not_to raise_error
      end
    end
  end

  describe '.validate_properties' do
    it 'accepts nil properties' do
      expect {
        described_class.validate_properties(nil)
      }.not_to raise_error
    end

    it 'accepts empty hash' do
      expect {
        described_class.validate_properties({})
      }.not_to raise_error
    end

    it 'raises error when properties is not a hash' do
      expect {
        described_class.validate_properties('invalid')
      }.to raise_error(ArgumentError, "Expression properties must be a hash")
    end

    it 'validates each property definition' do
      properties = {
        user_id: { type: 'string' },
        is_premium: { type: 'boolean' },
        age: { type: 'number' }
      }
      expect {
        described_class.validate_properties(properties)
      }.not_to raise_error
    end

    it 'raises error for invalid property definition' do
      properties = {
        user_id: { type: 'string' },
        invalid_prop: 'not_a_hash'
      }
      expect {
        described_class.validate_properties(properties)
      }.to raise_error(ArgumentError, "Property definition for 'invalid_prop' must be a hash")
    end
  end

  describe '.type_for' do
    let(:properties) do
      {
        user_id: { type: 'string' },
        is_premium: { 'type' => 'boolean' }
      }
    end

    it 'returns type for existing property with symbol key' do
      expect(described_class.type_for(properties, :user_id)).to eq('string')
    end

    it 'returns type for existing property with string key' do
      expect(described_class.type_for(properties, :is_premium)).to eq('boolean')
    end

    it 'returns nil for non-existent property' do
      expect(described_class.type_for(properties, :nonexistent)).to be_nil
    end

    it 'returns nil for nil properties' do
      expect(described_class.type_for(nil, :user_id)).to be_nil
    end
  end

  describe '.property_names' do
    it 'returns empty array for nil properties' do
      expect(described_class.property_names(nil)).to eq([])
    end

    it 'returns empty array for empty properties' do
      expect(described_class.property_names({})).to eq([])
    end

    it 'returns property names' do
      properties = {
        user_id: { type: 'string' },
        is_premium: { type: 'boolean' }
      }
      expect(described_class.property_names(properties)).to eq([:user_id, :is_premium])
    end
  end

  describe '.valid_property?' do
    let(:properties) do
      {
        user_id: { type: 'string' },
        age: { type: 'number' }
      }
    end

    it 'returns true for existing property' do
      expect(described_class.valid_property?(properties, 'user_id')).to be(true)
    end

    it 'returns false for non-existing property' do
      expect(described_class.valid_property?(properties, 'invalid')).to be(false)
    end

    it 'returns true for nil properties (backward compatibility)' do
      expect(described_class.valid_property?(nil, 'any')).to be(true)
    end
  end

  describe '.valid_operator_for_property?' do
    let(:properties) do
      {
        plan: { type: 'string' },
        age: { type: 'number' },
        active: { type: 'boolean' }
      }
    end

    it 'allows equality operators for string properties' do
      expect(described_class.valid_operator_for_property?(properties, 'plan', 'eq')).to be(true)
      expect(described_class.valid_operator_for_property?(properties, 'plan', 'ne')).to be(true)
    end

    it 'disallows comparison operators for string properties' do
      expect(described_class.valid_operator_for_property?(properties, 'plan', 'gt')).to be(false)
    end

    it 'allows all operators for numeric properties' do
      %w(eq ne gt gte lt lte).each do |op|
        expect(described_class.valid_operator_for_property?(properties, 'age', op)).to be(true)
      end
    end

    it 'allows only equality operators for boolean properties' do
      expect(described_class.valid_operator_for_property?(properties, 'active', 'eq')).to be(true)
      expect(described_class.valid_operator_for_property?(properties, 'active', 'ne')).to be(true)
      expect(described_class.valid_operator_for_property?(properties, 'active', 'gt')).to be(false)
    end

    it 'returns true for nil properties (backward compatibility)' do
      expect(described_class.valid_operator_for_property?(nil, 'any', 'gt')).to be(true)
    end
  end

  describe '.valid_operators_for_type' do
    it 'returns equality operators for string type' do
      expect(described_class.valid_operators_for_type('string')).to eq(%w(eq ne))
    end

    it 'returns all operators for number type' do
      expect(described_class.valid_operators_for_type('number')).to eq(%w(eq ne gt gte lt lte))
    end

    it 'returns equality operators for boolean type' do
      expect(described_class.valid_operators_for_type('boolean')).to eq(%w(eq ne))
    end

    it 'returns empty array for unknown type' do
      expect(described_class.valid_operators_for_type('unknown')).to eq([])
    end
  end
end
