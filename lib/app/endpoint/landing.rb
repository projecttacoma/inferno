# frozen_string_literal: true

module Inferno
  class App
    class Endpoint
      # Home provides a Sinatra endpoint for accessing Inferno.
      # Home serves the index page and landing page
      class Landing < Endpoint
        set :prefix, '/'

        # Return the index page of the application
        get '/' do
          logger.info 'loading index page.'
          render_index
        end

        get '/landing/?' do
          # Custom landing page intended to be overwritten for branded deployments
          erb :landing
        end

        # Serve our public key in a JWKS
        get '/jwks' do
          Inferno::JWKS.to_json
        end
      end
    end
  end
end
