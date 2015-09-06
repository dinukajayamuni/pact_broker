require 'pact/consumer_contract'
require 'pact/consumer_contract/service_consumer'
require 'pact/consumer_contract/service_provider'
# require 'pact/consumer_contract/interaction'
require 'pact_broker/my/group'
require 'pact_broker/my/interaction'

module PactBroker
  module My
  class ConsumerContract < Pact::ConsumerContract
    attr_accessor :groups

    def initialize(attributes = {})
      @interactions = attributes[:interactions] || []
      @consumer = attributes[:consumer]
      @provider = attributes[:provider]
      @groups = attributes[:groups] || []
    end

    def self.from_hash(hash)
      hash = symbolize_keys(hash)
      new(
          :consumer => Pact::ServiceConsumer.from_hash(hash[:consumer]),
          :provider => Pact::ServiceProvider.from_hash(hash[:provider]),
          :interactions => hash[:interactions].nil? ? [] : hash[:interactions].collect { |hash| PactBroker::My::Interaction.from_hash(hash)},
          :groups => hash[:groups].nil? ? [] : hash[:groups].collect { |hash| PactBroker::My::Group.from_hash(hash)}
      )
    end
  end
    end
end
