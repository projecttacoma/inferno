# frozen_string_literal: true

module Inferno
  class SmartBulkData
    def self.initialize_private_key(key_file)
      if File.exist?(key_file)
        key_str = File.read(key_file)
        key = OpenSSL::PKey::RSA.new(key_str)
      else
        key = OpenSSL::PKey::RSA.generate(2048)
        File.write(key_file, key.export)
      end

      key
    end

    def self.create_jwks(pkey)
      jwk = JSON::JWK.new(pkey.public_key)
      JSON::JWK::Set.new(jwk)
    end
  end
end
