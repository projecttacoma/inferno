# frozen_string_literal: true

require_relative '../../utils/measure_operations'

module Inferno
    module Sequence
      class MeasureSequence < SequenceBase
        include MeasureOperations

        title 'FHIR Quality Reporting'
  
        test_id_prefix 'eCQM'
  
        requires :url, :measure_id, :period_start, :period_end, :patient_id
  
        description 'Tests measure operations for a given FHIR Measure'
  
        test 'Evaluate Measure' do
          metadata do
            id '01'
            link 'https://hl7.org/fhir/STU3/measure-operations.html#evaluate-measure'
            desc 'Run the $evaluate-measure operation for an individual that should be in the IPP and Denominator'
          end

          # Parameters appended to the url for $evaluate-measure call
          PARAMS = {
            patient: @instance.patient_id,
            periodStart: @instance.period_start,
            periodEnd: @instance.period_end
          }

          EXPECTED_RESULTS = {
            :'initial-population' => 1,
            numerator: 1,
            denominator: 1
          }

          evaluate_measure_response = evaluate_measure(@instance.measure_id, PARAMS)
          assert_response_ok evaluate_measure_response

          # Load response body into a FHIR MeasureReport class
          measure_report = FHIR::STU3::from_contents(evaluate_measure_response.body)
          group = measure_report&.group[0]
          assert(!group.nil?)

          # Check matching values for each population in the group
          group.population.each do |p|
            code = p.code&.coding[0]&.code
            assert(!code.nil?)
            assert_equal(EXPECTED_RESULTS[code.to_sym], p.count, "Expected #{code} count and actual #{code} count are not equal")
          end
        end
      end
    end
  end
  