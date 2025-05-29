RSpec.describe Flipper::UI::Actions::ExpressionGate do
  let(:token) do
    if Rack::Protection::AuthenticityToken.respond_to?(:random_token)
      Rack::Protection::AuthenticityToken.random_token
    else
      'a'
    end
  end
  let(:session) do
    { :csrf => token, 'csrf' => token, '_csrf_token' => token }
  end

  describe 'POST /features/:feature/expression' do
    context 'with enable operation' do
      before do
        flipper.disable :search
        post 'features/search/expression',
             {
               'operation' => 'enable',
               'expression_property' => 'plan',
               'expression_operator' => 'eq',
               'expression_value' => 'basic',
               'authenticity_token' => token
             },
             'rack.session' => session
      end

      it 'enables the feature with expression' do
        expect(flipper.feature(:search).enabled_gate_names).to include(:expression)
      end

      it 'sets the correct expression' do
        expected_expression = { "Equal" => [{ "Property" => ["plan"] }, "basic"] }
        expect(flipper.feature(:search).expression.value).to eq(expected_expression)
      end

      it 'redirects back to feature' do
        expect(last_response.status).to be(302)
        expect(last_response.headers['location']).to eq('/features/search')
      end
    end

    context 'with disable operation' do
      before do
        expression = Flipper::Expression.build({ "Equal" => [{ "Property" => ["plan"] }, "basic"] })
        flipper.enable_expression :search, expression
        post 'features/search/expression',
             {
               'operation' => 'disable',
               'authenticity_token' => token
             },
             'rack.session' => session
      end

      it 'disables the expression gate' do
        expect(flipper.feature(:search).enabled_gate_names).not_to include(:expression)
      end

      it 'redirects back to feature' do
        expect(last_response.status).to be(302)
        expect(last_response.headers['location']).to eq('/features/search')
      end
    end

    context 'with invalid expression parameters' do
      before do
        flipper.disable :search
        post 'features/search/expression',
             {
               'operation' => 'enable',
               'expression_property' => '',
               'expression_operator' => 'eq',
               'expression_value' => 'basic',
               'authenticity_token' => token
             },
             'rack.session' => session
      end

      it 'redirects back to feature with error' do
        expect(last_response.status).to be(302)
        expect(last_response.headers['location']).to include('/features/search?error=')
      end
    end

    context 'with missing operator' do
      before do
        flipper.disable :search
        post 'features/search/expression',
             {
               'operation' => 'enable',
               'expression_property' => 'plan',
               'expression_operator' => '',
               'expression_value' => 'basic',
               'authenticity_token' => token
             },
             'rack.session' => session
      end

      it 'redirects back to feature with error' do
        expect(last_response.status).to be(302)
        expect(last_response.headers['location']).to include('/features/search?error=')
      end
    end

    context 'with missing value' do
      before do
        flipper.disable :search
        post 'features/search/expression',
             {
               'operation' => 'enable',
               'expression_property' => 'plan',
               'expression_operator' => 'eq',
               'expression_value' => '',
               'authenticity_token' => token
             },
             'rack.session' => session
      end

      it 'redirects back to feature with error' do
        expect(last_response.status).to be(302)
        expect(last_response.headers['location']).to include('/features/search?error=')
      end
    end

    context 'with configured properties validation' do
      before do
        allow(Flipper::UI.configuration).to receive(:expression_properties).and_return({
          plan: { type: 'string' },
          age: { type: 'number' }
        })
      end

      context 'with invalid property' do
        before do
          flipper.disable :search
          post 'features/search/expression',
               {
                 'operation' => 'enable',
                 'expression_property' => 'invalid_prop',
                 'expression_operator' => 'eq',
                 'expression_value' => 'basic',
                 'authenticity_token' => token
               },
               'rack.session' => session
        end

        it 'redirects back to feature with error' do
          expect(last_response.status).to be(302)
          expect(last_response.headers['location']).to include('/features/search?error=')
          expect(last_response.headers['location']).to include('not+configured')
        end
      end

      context 'with invalid operator for property type' do
        before do
          flipper.disable :search
          post 'features/search/expression',
               {
                 'operation' => 'enable',
                 'expression_property' => 'plan',
                 'expression_operator' => 'gt',
                 'expression_value' => 'basic',
                 'authenticity_token' => token
               },
               'rack.session' => session
        end

        it 'redirects back to feature with error' do
          expect(last_response.status).to be(302)
          expect(last_response.headers['location']).to include('/features/search?error=')
          expect(last_response.headers['location']).to include('not+valid')
        end
      end
    end

    context 'with space in feature name' do
      before do
        flipper.disable "sp ace"
        post 'features/sp%20ace/expression',
             {
               'operation' => 'enable',
               'expression_property' => 'plan',
               'expression_operator' => 'eq',
               'expression_value' => 'basic',
               'authenticity_token' => token
             },
             'rack.session' => session
      end

      it 'enables the feature with expression' do
        expect(flipper.feature("sp ace").enabled_gate_names).to include(:expression)
      end

      it 'redirects back to feature' do
        expect(last_response.status).to be(302)
        expect(last_response.headers['location']).to eq('/features/sp+ace')
      end
    end
  end

  describe 'DELETE /features/:feature/expression' do
    before do
      expression = Flipper::Expression.build({ "Equal" => [{ "Property" => ["plan"] }, "basic"] })
      flipper.enable_expression :search, expression
      delete 'features/search/expression',
             { 'authenticity_token' => token },
             'rack.session' => session
    end

    it 'disables the expression gate' do
      expect(flipper.feature(:search).enabled_gate_names).not_to include(:expression)
    end

    it 'redirects back to feature' do
      expect(last_response.status).to be(302)
      expect(last_response.headers['location']).to eq('/features/search')
    end
  end

  describe 'expression parameter parsing' do
    let(:action) { described_class.new(flipper, double('request')) }

    it 'supports all comparison operators' do
      operators = {
        'eq' => 'Equal',
        'ne' => 'NotEqual',
        'gt' => 'GreaterThan',
        'gte' => 'GreaterThanOrEqualTo',
        'lt' => 'LessThan',
        'lte' => 'LessThanOrEqualTo'
      }

      operators.each do |op, expression_type|
        allow(action).to receive(:params).and_return({
          'expression_property' => 'age',
          'expression_operator' => op,
          'expression_value' => '25'
        })

        result = action.send(:parse_expression_params)
        expect(result).to eq({
          expression_type => [{ "Property" => ["age"] }, 25]
        })
      end
    end

    it 'converts numeric values' do
      allow(action).to receive(:params).and_return({
        'expression_property' => 'age',
        'expression_operator' => 'gt',
        'expression_value' => '25'
      })

      result = action.send(:parse_expression_params)
      expect(result['GreaterThan'][1]).to eq(25)
    end

    it 'converts boolean values' do
      allow(action).to receive(:params).and_return({
        'expression_property' => 'premium',
        'expression_operator' => 'eq',
        'expression_value' => 'true'
      })

      result = action.send(:parse_expression_params)
      expect(result['Equal'][1]).to eq(true)
    end

    it 'handles string values' do
      allow(action).to receive(:params).and_return({
        'expression_property' => 'plan',
        'expression_operator' => 'eq',
        'expression_value' => 'basic'
      })

      result = action.send(:parse_expression_params)
      expect(result['Equal'][1]).to eq('basic')
    end
  end
end
