RSpec.describe Flipper::UI::Decorators::Feature do
  let(:source)  { {} }
  let(:adapter) { Flipper::Adapters::Memory.new(source) }
  let(:flipper) { build_flipper }
  let(:feature) { flipper[:some_awesome_feature] }

  subject do
    described_class.new(feature)
  end

  describe '#initialize' do
    it 'sets the feature' do
      expect(subject.feature).to be(feature)
    end
  end

  describe '#pretty_name' do
    it 'capitalizes each word separated by underscores' do
      expect(subject.pretty_name).to eq('Some Awesome Feature')
    end
  end

  describe '#<=>' do
    let(:on) do
      flipper.enable(:on_a)
      described_class.new(flipper[:on_a])
    end

    let(:on_b) do
      flipper.enable(:on_b)
      described_class.new(flipper[:on_b])
    end

    let(:conditional) do
      flipper.enable_percentage_of_time :conditional_a, 5
      described_class.new(flipper[:conditional_a])
    end

    let(:off) do
      described_class.new(flipper[:off_a])
    end

    it 'sorts :on before :conditional' do
      expect((on <=> conditional)).to be(-1)
    end

    it 'sorts :on before :off' do
      expect((on <=> off)).to be(-1)
    end

    it 'sorts :conditional before :off' do
      expect((conditional <=> off)).to be(-1)
    end

    it 'sorts on key for identical states' do
      expect((on <=> on_b)).to be(-1)
    end
  end

  describe '#has_expression?' do
    it 'returns false when no expression is set' do
      expect(subject.has_expression?).to be(false)
    end

    it 'returns true when expression is set' do
      expression = Flipper.property(:plan).eq("basic")
      feature.enable_expression(expression)
      expect(subject.has_expression?).to be(true)
    end

    it 'returns false when expression value is empty' do
      allow(feature).to receive(:expression_value).and_return({})
      expect(subject.has_expression?).to be(false)
    end
  end

  describe '#expression_summary' do
    it 'returns "none" when no expression is set' do
      expect(subject.expression_summary).to eq("none")
    end

    it 'returns formatted summary for simple comparison' do
      expression = Flipper.property(:plan).eq("basic")
      feature.enable_expression(expression)
      expect(subject.expression_summary).to eq('plan = "basic"')
    end

    it 'returns formatted summary for numeric comparison' do
      expression = Flipper.property(:age).gte(21)
      feature.enable_expression(expression)
      expect(subject.expression_summary).to eq("age ≥ 21")
    end

    it 'returns "complex expression" for unsupported formats' do
      allow(feature).to receive(:expression_value).and_return({"Any" => []})
      expect(subject.expression_summary).to eq("complex expression")
    end
  end

  describe '#expression_description' do
    it 'returns "No expression set" when no expression is set' do
      expect(subject.expression_description).to eq("No expression set")
    end

    it 'returns verbose description for simple comparison' do
      expression = Flipper.property(:plan).eq("basic")
      feature.enable_expression(expression)
      expect(subject.expression_description).to eq('plan equals "basic"')
    end

    it 'returns verbose description for numeric comparison' do
      expression = Flipper.property(:age).lt(18)
      feature.enable_expression(expression)
      expect(subject.expression_description).to eq("age is less than 18")
    end
  end

  describe '#gates_in_words' do
    it 'includes expression in the summary when expression is set' do
      expression = Flipper.property(:plan).eq("basic")
      feature.enable_expression(expression)
      expect(subject.gates_in_words).to include('actors with plan = "basic"')
    end

    it 'does not include expression when no expression is set' do
      expect(subject.gates_in_words).not_to include('expression')
    end
  end

  describe '#expression_state' do
    it 'returns :off when no expression is set' do
      expect(subject.expression_state).to eq(:off)
    end

    it 'returns :conditional when expression is set' do
      expression = Flipper.property(:plan).eq("basic")
      feature.enable_expression(expression)
      expect(subject.expression_state).to eq(:conditional)
    end
  end

  describe 'sorting with expressions' do
    let(:expression_feature) do
      flipper.enable_expression :expression_a, Flipper.property(:plan).eq("basic")
      described_class.new(flipper[:expression_a])
    end

    let(:boolean_feature) do
      flipper.enable :boolean_a
      described_class.new(flipper[:boolean_a])
    end

    let(:percentage_feature) do
      flipper.enable_percentage_of_time :percentage_a, 50
      described_class.new(flipper[:percentage_a])
    end

    let(:off_feature) do
      described_class.new(flipper[:off_a])
    end

    it 'sorts boolean before expression' do
      expect((boolean_feature <=> expression_feature)).to be(-1)
    end

    it 'sorts expression before percentage' do
      expect((expression_feature <=> percentage_feature)).to be(-1)
    end

    it 'sorts expression before off' do
      expect((expression_feature <=> off_feature)).to be(-1)
    end
  end
end
