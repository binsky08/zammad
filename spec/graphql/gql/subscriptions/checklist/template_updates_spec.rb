# Copyright (C) 2012-2024 Zammad Foundation, https://zammad-foundation.org/

require 'rails_helper'

RSpec.describe Gql::Subscriptions::Checklist::TemplateUpdates, type: :graphql do
  let(:agent)              { create(:agent) }
  let(:only_active)        { false }
  let(:variables)          { { onlyActive: only_active } }
  let(:mock_channel)       { build_mock_channel }
  let(:subscription) do
    <<~QUERY
      subscription checklistTemplateUpdates($onlyActive: Boolean = false) {
        checklistTemplateUpdates(onlyActive: $onlyActive) {
          checklistTemplates {
            id
            name
            active
          }
        }
      }
    QUERY
  end

  before do
    gql.execute(subscription, variables: variables, context: { channel: mock_channel })
  end

  context 'with an unauthenticated user' do
    it 'does not subscribe to template updates and returns an authorization error' do
      expect(gql.result.error_type).to eq(Exceptions::NotAuthorized)
    end
  end

  context 'with an authenticated user', authenticated_as: :agent do
    it 'subscribes to template updates' do
      expect(gql.result.data).not_to be_nil
    end

    it 'triggers after template create' do
      template = create(:checklist_template)

      result = mock_channel.mock_broadcasted_messages.first[:result]['data']['checklistTemplateUpdates']

      expect(result).to include('checklistTemplates' => include(
        include(
          'id' => gql.id(template),
        )
      ))
    end

    context 'with an existing template', authenticated_as: :authenticate do
      let(:template) { create(:checklist_template) }

      def authenticate
        template
        agent
      end

      it 'triggers after template update' do
        template.update!(name: 'foobar')

        result = mock_channel.mock_broadcasted_messages.first[:result]['data']['checklistTemplateUpdates']

        expect(result).to include('checklistTemplates' => include(
          include(
            'name' => 'foobar',
          )
        ))
      end

      it 'triggers after template destroy' do
        template.destroy!

        result = mock_channel.mock_broadcasted_messages.first[:result]['data']['checklistTemplateUpdates']

        expect(result).to include('checklistTemplates' => not_include(
          include(
            'id' => gql.id(template),
          )
        ))
      end
    end
  end
end
