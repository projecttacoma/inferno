# frozen_string_literal: true

require_relative '../../app/utils/measure_operations'
require_relative '../../app/utils/bundle'

module Inferno
  module Sequence
    class MeasureAvailability < SequenceBase
      include MeasureOperations
      include BundleParserUtil
      title 'Measure Availability'

      test_id_prefix 'measure_availability'
      requires :measure_to_test, :api_key, :auth_header

      description 'Ensure that a specific measure exists on test server'

      test 'Check Measure Availability' do
        metadata do
          id '01'
          link 'https://www.hl7.org/fhir/measure.html'
          description 'Check to make sure specified measure is available on test server'
        end

        # Look for matching measure from cqf-ruler datastore by resource id
        measure_identifier, measure_version = @instance.measure_to_test.split('|')

        @client.additional_headers = { 'x-api-key': @instance.api_key, 'Authorization': @instance.auth_header } if @instance.api_key && @instance.auth_header

        # Search system for measure by identifier and version
        query_response = @client.search(FHIR::Measure, search: { parameters: { identifier: measure_identifier, version: measure_version } })

        bundle = FHIR::Bundle.new JSON.parse(query_response.body)

        assert bundle.total.positive?, "Expected to find measure with identifier #{measure_identifier} and version #{measure_version}"
      end
    end
  end
end
