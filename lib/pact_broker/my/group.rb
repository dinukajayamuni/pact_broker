require 'pact/symbolize_keys'

module PactBroker
  module My
    class Group
      include Pact::SymbolizeKeys

      attr_accessor :title
      attr_accessor :id
      attr_accessor :groups
      attr_accessor :interactions

      def initialize options
        @title = options[:title]
        @id = options[:id]
        @groups = !options[:groups].nil? ? options[:groups].collect { |hash| PactBroker::My::Group.from_hash(hash) } : []
        @interactions = options[:interactions] || []
      end

      def to_s
        title
      end

      def to_hash
        {
            title: title,
            id: id,
            groups: groups.collect { |group| group.to_hash },
            interactions: interactions
        }
      end

      def as_json options = {}
        to_hash
      end

      def self.from_hash hash
        new(symbolize_keys(hash))
      end
    end
  end
end