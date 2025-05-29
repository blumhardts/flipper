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


end
