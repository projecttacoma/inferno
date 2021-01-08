# frozen_string_literal: true

require File.expand_path '../test_helper.rb', __dir__
require_relative '../../lib/app/utils/measure_operations'

class MeasureOperationsTest < MiniTest::Test
  include Inferno::MeasureOperations

  DATA_REQS = [
    {
      'type' => 'Procedure',
      'codeFilter' => [
        {
          'path' => 'code',
          'valueSet' => 'http://example.com/vs-1'
        }
      ]
    },
    {
      'type' => 'Encounter',
      'codeFilter' => [
        {
          'path' => 'type',
          'valueSet' => 'http://example.com/vs-2'
        }
      ]
    },
    {
      'type' => 'Condition',
      'codeFilter' => [
        {
          'path' => 'code',
          'code' => [
            {
              'code' => 'example-code',
              'system' => 'http://example.com/example-system'
            }
          ]
        }
      ]
    }
  ].map { |dr| FHIR::DataRequirement.new(dr) }

  EXPECTED_QUERIES = [
    {
      'endpoint' => 'Procedure',
      'params' => {
        'code:in' => 'http://example.com/vs-1'
      }
    },
    {
      'endpoint' => 'Encounter',
      'params' => {
        'type:in' => 'http://example.com/vs-2'
      }
    },
    {
      'endpoint' => 'Condition',
      'params' => {
        'code' => 'example-code'
      }
    }
  ].freeze

  def test_data_requirements_queries
    dr = get_data_requirements_queries(DATA_REQS)
    assert_equal dr, EXPECTED_QUERIES
  end
end
