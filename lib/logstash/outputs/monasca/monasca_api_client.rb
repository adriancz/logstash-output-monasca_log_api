=begin
Copyright 2015 FUJITSU LIMITED

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License
is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied. See the License for the specific language governing permissions and limitations under
the License.
=end

# encoding: utf-8

require 'rest-client'
require 'logger'

# relative requirements
require_relative '../helper/url_helper'

# This class creates a connection to monasca-api
module LogStash::Outputs
  module Monasca
    class MonascaApiClient
      
      def initialize host, port
        @logger = Cabin::Channel.get(LogStash)
        @rest_client = RestClient::Resource.new(LogStash::Outputs::Helper::UrlHelper.generate_url(host, port, '/v2.0').to_s)
      end
    
      # Send log events to monasca-api, requires token
      def send_log(event, token, dimensions)
        #begin
        request(event, token, dimensions)
        @logger.debug("Successfully send event=#{event}, with token=#{token} and dimensions=#{dimensions} to monasca-api")
      end

      private

      def request(event, token, dimensions)
        if dimensions
          @rest_client['log']['single'].post(
            event.to_s, 
            :x_auth_token => token, 
            :content_type => 'application/json', 
            :x_dimensions => dimensions
          )
        else
          @rest_client['log']['single'].post(
            event.to_s, 
            :x_auth_token => token, 
            :content_type => 'application/json'
          )
        end
      end
    
    end
  end
end