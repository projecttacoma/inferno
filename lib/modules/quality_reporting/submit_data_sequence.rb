# frozen_string_literal: true

require_relative '../../app/utils/measure_operations'
require_relative '../../app/utils/bundle'

module Inferno
  module Sequence
    class SubmitDataSequence < SequenceBase
      include MeasureOperations
      include BundleParserUtil
      title 'Submit Data'

      test_id_prefix 'submit_data'

      requires :data_requirements_queries

      description 'Ensure that resources relevant to a measure can be submitted via the $submit-data operation'

      test 'Submit Data valid submission' do
        metadata do
          id '01'
          link 'https://www.hl7.org/fhir/measure-operation-submit-data.html'
          description 'Submit resources relevant to a measure, and then verify they persist on the server.'
        end

        assert(!@instance.measure_to_test.nil?, 'No measure selected. You must run the Prerequisite sequences prior to running Reporting Actions sequences.')

        @client.additional_headers = { 'x-api-key': @instance.api_key, 'Authorization': @instance.auth_header } if @instance.api_key && @instance.auth_header

        # TODO: How do we decide which patient we are submitting for, if applicable???

        resources = get_data_requirements_resources(@instance.data_requirements_queries)
        measure_report = create_measure_report(@instance.measure_to_test, '2019', '2019')

        # Submit the data
        submit_data_response = submit_data(@instance.measure_to_test, resources, measure_report)
        assert_response_ok(submit_data_response)

        resources.push(measure_report)

        # GET and assert presence of all submitted resources
        resources.each do |r|
          identifier = r.identifier&.first&.value
          assert !identifier.nil?

          # Search for resource by identifier
          search_response = @client.search(r.class, search: { parameters: { identifier: identifier } })
          assert_response_ok search_response
          search_bundle = search_response.resource

          # Expect a non-empty searchset Bundle
          assert(search_bundle.total.positive?, "Search for a #{r.resourceType} with identifier #{identifier} returned no results")
        end
      end

      test 'Submit Data single resource submission' do
        metadata do
          id '02'
          link 'https://www.hl7.org/fhir/measure-operation-submit-data.html'
          description 'Submit resources relevant to a measure, and then verify they persist on the server.'
        end

        assert(!@instance.measure_to_test.nil?, 'No measure selected. You must run the Prerequisite sequences prior to running Reporting Actions sequences.')

        @client.additional_headers = { 'x-api-key': @instance.api_key, 'Authorization': @instance.auth_header } if @instance.api_key && @instance.auth_header

        resources = [get_data_requirements_resources(@instance.data_requirements_queries).sample]
        measure_report = create_measure_report(@instance.measure_to_test, '2019', '2019')

        # Submit the data
        submit_data_response = submit_data(@instance.measure_to_test, resources, measure_report)
        assert_response_ok(submit_data_response)

        resources.push(measure_report)

        # GET and assert presence of all submitted resources
        resources.each do |r|
          identifier = r.identifier&.first&.value
          assert !identifier.nil?

          # Search for resource by identifier
          search_response = @client.search(r.class, search: { parameters: { identifier: identifier } })
          assert_response_ok search_response
          search_bundle = search_response.resource

          # Expect a non-empty searchset Bundle
          assert(search_bundle.total.positive?, "Search for a #{r.resourceType} with identifier #{identifier} returned no results")
        end
      end
    end
  end
end
