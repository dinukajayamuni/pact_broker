require 'pact/consumer_contract/interaction'
module PactBroker
  module My
    class Interaction < Pact::Interaction
      attr_accessor :group

      def initialize attributes = {}
        super(attributes)
        @group = attributes[:group]
      end

      def to_hash
        interaction_hash = super
        interaction_hash[:group] = @group
      end
    end
  end
end
