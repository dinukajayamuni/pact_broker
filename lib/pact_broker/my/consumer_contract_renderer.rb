require 'pact_broker/api/renderers/html_pact_renderer'
require 'pact/doc/markdown/consumer_contract_renderer'
require 'pact/doc/markdown/interaction_renderer'
require 'pact_broker/my/consumer_contract'
require 'pact/doc/markdown/consumer_contract_renderer'

module PactBroker
  module My
    class ConsumerContractRenderer < Pact::Doc::Markdown::ConsumerContractRenderer
      def call
        title + summaries_title + render(consumer_contract.groups)
      end

      def render(groups)
        if (!groups.nil? && groups.length > 0)
          html = ''
          consumer_contract.interactions.each do |interaction|
            if (!associate_interaction_with_group(groups, interaction))
              html += render_interaction(interaction)
            end
          end
          groups_html = render_groups(groups)
          return '<div class="css-treeview">' + html + groups_html + '</div>'
        else
          Pact::Doc::Markdown::ConsumerContractRenderer.call consumer_contract
        end
      end

      def associate_interaction_with_group(groups, interaction)
        if (!interaction.group.nil? && !groups.nil? && groups.length > 0)
          groups.each do |group|
            if (interaction.group == group.id)
              group.interactions << render_interaction(interaction)
              return true
            else
              if (associate_interaction_with_group(group.groups, interaction))
                return true
              end
            end
          end
        end
        return false
      end

      def render_groups(groups, html = '')
        if (!groups.nil? && groups.length > 0)
          groups.each do |group|
            html += "<ul style=\"margin-bottom:10px\"><li style=\"list-style-type:square\"><a href=\"##{group.id}\" name=\"#{group.id}\"></a><input type=\"checkbox\" id=\"#{group.id}\" /><label style=\"font-weight:bold;\" for=\"#{group.id}\">#{group.title}</label><ul><li style=\"margin-top:10px;\">"
            group.interactions.each do |interaction|
              html += interaction
            end
            html += render_groups(group.groups, '')
            html += '</li></ul></li></ul>'
          end
        end
        return html
      end

      def render_interaction(interaction)
        interaction_renderer = Pact::Doc::Markdown::InteractionRenderer.new interaction, consumer_contract
        interaction_vm = interaction_renderer.interaction
        suffix ="#{interaction_vm.description(true)} #{interaction_vm.has_provider_state? ? " given #{interaction_vm.provider_state}" : ''}"
        mark_down = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true, :lax_spacing => true)
        interaction_html = mark_down.render(interaction_renderer.render_full_interaction)
        "<ul style=\"margin-bottom:10px;\"><li style=\"list-style-type:square\"><a name=\"#{interaction_vm.id}\"></a><input type=\"checkbox\" id=\"#{interaction_vm.id}\" /><label for=\"#{interaction_vm.id}\">#{suffix}</label><ul><li style=\"margin-top:10px;\">#{interaction_html}</li></ul></li></ul>"
      end
    end
  end
end
