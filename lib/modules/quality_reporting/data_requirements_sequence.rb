# frozen_string_literal: true

require_relative '../../app/utils/measure_operations'

module Inferno
  module Sequence
    class DataRequirementsSequence < SequenceBase
      include MeasureOperations
      title 'Data Requirements'

      test_id_prefix 'data_requirements'

      description 'Ensure that data requirements and parameters relevant to a measure can be requested via the $data-requirements operation'

      # Parameters appended to the url for $data-requirements call
      PARAMS = {
        'periodStart': '2019-01-01',
        'periodEnd': '2019-12-31'
      }.freeze

      test 'Data Requirements valid response' do
        metadata do
          id '01'
          link 'https://www.hl7.org/fhir/measure-operation-data-requirements.html'
          description 'Request data requirements relevant to a measure, and then verify module definition results.'
        end

        assert(!@instance.measure_to_test.nil?, 'No measure selected. You must run the Prerequisite sequences prior to running this sequence.')
        
        # Get data requirements from cqf-ruler
        expected_results_library = get_data_requirements(measure_id, PARAMS.compact)
        expectedDR = expected_results_library.dataRequirement

        # Get data requirements from client
        data_requirements_response = data_requirements(measure_id, PARAMS.compact)
        assert_response_ok data_requirements_response

        # Load response body into a FHIR Library class, expected to contain dataRequirement array
        data_library = FHIR.from_contents(data_requirements_response.body)
        actualDR = data_library&.dataRequirement
        assert(!actualDR.nil?, "Client provided no data requirements for measure #{measure_id}")

        # Compare data requirements to expected
        assert((expectedDR-actualDR).blank?, "Client data-requirements is missing expected data requirements for measure #{measure_id}")
        assert((actualDR-expectedDR).blank?, "Client data-requirements contains unexpected data requirements for measure #{measure_id}")

      end
    end
  end
end
