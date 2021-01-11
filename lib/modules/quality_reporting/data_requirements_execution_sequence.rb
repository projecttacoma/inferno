# frozen_string_literal: true

require_relative '../../app/utils/measure_operations'

module Inferno
  module Sequence
    class DataRequirementsExecutionSequence < SequenceBase
      include MeasureOperations
      title 'Data Requirements Execution'

      test_id_prefix 'data_requirements_execution'

      requires :data_requirements_queries

      description 'Ensure that data requirements relevant to a measure can be used to execute corresponding data queries'

      test 'Generated Data Requirements FHIR query valid response' do
        metadata do
          id '01'
          link 'https://www.hl7.org/fhir/measure-operation-data-requirements.html'
          description 'Generate data requirements queries, execute wueries, and verify valid response.'
        end

        assert(!@instance.data_requirements_queries.nil?, 'No data requirements have been collected. You must successfully run the DataRequirements sequence prior to running this sequence.')

        # execute queries
        @instance.data_requirements_queries.each do |q|
          expected_data = get_query(q[:endpoint], q[:params]) # from cqf ruler
          response = query(q[:endpoint], q[:params]) # from client

          # validate response
          assert_response_ok response
          data = FHIR.from_contents(response.body)
          assert(!data.nil?, "Client provided no data response to query #{q}")
          assert_equal(expected_data, data, "Client response did not match expected for query #{q}")

          # TODO: make results available to next (submit data) sequence
        end
      end
    end
  end
end
