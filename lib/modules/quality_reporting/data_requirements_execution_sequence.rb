# frozen_string_literal: true

require_relative '../../app/utils/measure_operations'

module Inferno
  module Sequence
    class DataRequirementsExecutionSequence < SequenceBase
      include MeasureOperations
      title 'Data Requirements Execution'

      test_id_prefix 'data_requirements_execution'

      description 'Ensure that data requirements relevant to a measure can be used to execute corresponding data queries'

      # # TODO: do any parameters need to be passed in with the generated queries?
      PARAMS = {
        # 'periodStart': '2019-01-01',
        # 'periodEnd': '2019-12-31'
      }.freeze

      test 'Generated Data Requirements FHIR query valid response' do
        metadata do
          id '01'
          link 'https://www.hl7.org/fhir/measure-operation-data-requirements.html'
          description 'Generate data requirements queries, execute wueries, and verify valid response.'
        end

        
        assert(!@instance.data_requirements.nil?, 'No data requirements have been collected. You must successfully run the DataRequirements sequence prior to running this sequence.')
        # TODO: use data requirements from previous (data requirements) sequence to generate data requirements FHIR queries
        @instance.data_requirements
        dr_queries = []

        # TODO: validate the below. 
        # Assumes dr_queries is an array of endpoint url strings that can be added to the client or cqf ruler base and executed
        # Creates submission_data as an array of json responses each corresponding to a query

        @instance.submission_data = []
        # execute queries
        dr_queries.each do |q|
          expected_data = get_query(q, PARAMS.compact) # from cqf ruler
          response = query(q, PARAMS.compact) # from client

          # validate response
          assert_response_ok response
          data = FHIR.from_contents(response.body)
          assert(!data.nil?, "Client provided no data response to query #{q}")
          assert_equal(expected_data, data, "Client response did not match expected for query #{q}")

          # make results available to next (submit data) sequence
          @instance.submission_data << data
        end
      end
    end
  end
end
