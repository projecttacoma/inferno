# frozen_string_literal: true

require File.expand_path '../test_helper.rb', __dir__

class SmartBulkDataTest < MiniTest::Test
  def test_key_init
    # Get a temp file path for the key
    file = Tempfile.new('tmp_keyfile')
    file_path = file.path
    file.delete

    # Generate a new key
    Inferno::SmartBulkData.initialize_private_key(file_path)
    assert(File.exist?(file_path), "Expect keyfile to have been created at: #{file_path}")
    new_key = OpenSSL::PKey::RSA.new File.read(file_path)

    # Use an existing key
    existing_key = Inferno::SmartBulkData.initialize_private_key(file_path)
    assert(new_key.to_s == existing_key.to_s, 'Expect existing keyfile to be reused.')
  end
end
