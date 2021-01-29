# frozen_string_literal: true

module Inferno
  module Models
    class DataRequirementsQuery
      include DataMapper::Resource

      property :id, String, key: true, default: proc { Inferno::SecureRandomBase62.generate(64) }
      property :endpoint, String
      property :params, Object

      belongs_to :testing_instance
    end
  end
end
