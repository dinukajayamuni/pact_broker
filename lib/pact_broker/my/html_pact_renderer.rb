require 'pact_broker/api/renderers/html_pact_renderer'
require 'pact_broker/my/consumer_contract_renderer'
require 'pact_broker/my/consumer_contract'

module PactBroker
  module My
    class HtmlPactRenderer < PactBroker::Api::Renderers::HtmlPactRenderer
      def head
        "<link rel='stylesheet' type='text/css' href='/stylesheets/my.css'>" + super
      end

      def markdown
        PactBroker::My::ConsumerContractRenderer.call consumer_contract
      rescue NotAPactError
        heading = "### A contract between #{@pact.consumer.name} and #{@pact.provider.name}"
        warning = "_Note: this contract could not be parsed to a Pact, showing raw content instead._"
        pretty_json = JSON.pretty_generate(@pact.content_hash)
        "#{heading}\n#{warning}\n```json\n#{pretty_json}\n```\n"
      end

      def consumer_contract
        PactBroker::My::ConsumerContract.from_json(@json_content)
      rescue => e
        logger.warn "#{e.class} #{e.message} #{e.backtrace.join("\n")}"
        logger.warn "Could not parse the following content to a Pact, showing raw content instead: #{@json_content}"
        raise NotAPactError
      end
    end
  end
end