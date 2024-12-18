require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Mantle < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'read:apps, read:customers, read:users, read:plans, write:customers'
      SCOPE_DELIMITER = ','
      MINUTE = 60
      CODE_EXPIRES_AFTER = 10 * MINUTE

      
      # Give your strategy a name.
      option :name, "mantle"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :authorize_url => 'https://app.heymantle.com/oauth/authorize',
        :token_url => 'https://app.heymantle.com/api/oauth/token'
      }

      option :callback_url, '/auth/mantle/callback'
      option :myshopify_domain, 'myshopify.com'
      option :client_id
      option :secret
      option :token_path, 'https://app.heymantle.com/api/oauth/token'

      # When `true`, the user's permission level will apply (in addition to
      # the requested access scope) when making API requests to Shopify.
      option :per_user_permissions, false

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid {  raw_info['client']['id'] }

      info do
        {
          user_id: raw_info['user']['id'],
          organization_id: raw_info['user']['organization_id'],
          client_id: raw_info['client']['id'],
          handle: raw_info['client']['handle']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def normalized_scopes(scopes)
        scope_list = scopes.to_s.split(SCOPE_DELIMITER).map(&:strip).reject(&:empty?).uniq
      end

      def authorize_params
        super.tap do |params|
          params[:scope] = normalized_scopes(params[:scope] || DEFAULT_SCOPE).join(SCOPE_DELIMITER)
          # response_type=code
          # &client_id=a6c31dfd-9d42-4dbf-bd93-c34e35303d44
        end
      end

      def raw_info
        @parsed_info ||= access_token.response.parsed
      end

      def callback_url
        options[:callback_url] || full_host + script_name + callback_path
      end

      def self.hmac_sign(encoded_params, secret)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, secret, encoded_params)
      end

      private

      def validate_signature(secret)
        params = request.GET
        calculated_signature = self.class.hmac_sign(self.class.encoded_params_for_signature(params), secret)
        Rack::Utils.secure_compare(calculated_signature, params['hmac'])
      end
    end
  end
end

