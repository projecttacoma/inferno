# frozen_string_literal: true

require_relative '../../utils/measure_operations'
require_relative '../../utils/bundle'

module Inferno
  module Sequence
    class SubmitDataSequence < SequenceBase
      include MeasureOperations
      include BundleParserUtil
      title 'Submit Data'

      test_id_prefix 'submit_data'

      description 'Ensure that resources relevant to a measure can be submitted via the $submit-data operation'

      test 'Submit Data valid submission' do
        metadata do
          id '01'
          link 'https://www.hl7.org/fhir/measure-operation-submit-data.html'
          desc 'Submit resources relevant to a measure, and then verify they persist on the server.'
        end

        assert(!@instance.measure_to_test.nil?, 'No measure selected. You must run the Prerequisite sequences prior to running Reporting Actions sequences.')
        
        @client.additional_headers = { 'x-api-key': @instance.api_key, 'Authorization': @instance.auth_header }

        # Get the patient data to submit. We currently support cms124, cms130, cms165 only
        patient_bundle_path = case @instance.measure_to_test
                              when 'measure-exm124-FHIR3'
                                '../../../../resources/quality_reporting/CMS124/Bundle/cms124-patient-bundle.json'
                              when 'measure-exm130-FHIR3'
                                '../../../../resources/quality_reporting/CMS130/Bundle/cms130-patient-bundle.json'
                                # when 'measure-exm165-FHIR3'
                                # '../../../../resources/quality_reporting/CMS165/Bundle/cms165-patient-bundle.json'
                              end

        def search_resource(klass, identifier)
          @client.search(klass, search: { parameters: { identifier: identifier } })
        end

        patient_file = File.expand_path(patient_bundle_path, __dir__)
        patient_bundle = FHIR::STU3::Json.from_json(File.read(patient_file))
        resources = patient_bundle.entry.map(&:resource)
        patient = resources.first { |r| r.resourceType == 'Patient' }
        measure_report = create_measure_report(@instance.measure_to_test, patient.id, '2019', '2019')

        # Submit the data
        submit_data_response = submit_data(@instance.measure_to_test, resources, measure_report)
        assert_response_ok(submit_data_response)

        # Search for MeasureReport
        measure_report_identifier = measure_report[:identifier].first[:value]
        assert !measure_report_identifier.nil?, 'Expected MeasureReport to have an identifier'
        search_response = search_resource(FHIR::STU3::MeasureReport, measure_report_identifier)
        assert_response_ok search_response
        assert_non_empty_search search_response

        # GET and assert presence of all submitted resources
        resources.each do |r|
          identifier = r.identifier&.first&.value
          assert !identifier.nil?

          # Search for resource by identifier
          search_response = search_resource(r.class, identifier)
          assert_response_ok search_response

          # Expect a non-exmpty searchset Bundle
          assert_non_empty_search search_response
        end
      end
    end
  end
end
