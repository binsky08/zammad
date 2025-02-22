# Copyright (C) 2012-2024 Zammad Foundation, https://zammad-foundation.org/

module Gql::Mutations
  class Ticket::Checklist::TitleUpdate < BaseMutation
    description 'Update title of the ticket checklist.'

    argument :checklist_id, GraphQL::Types::ID, required: true, loads: Gql::Types::ChecklistType, description: 'ID of the ticket checklist to update.'
    argument :title, String, required: false, description: 'New value for the ticket checklist title.'

    field :checklist, Gql::Types::ChecklistType, null: true, description: 'Created checklist'

    def resolve(checklist:, title: '')
      checklist.update!(name: title)

      {
        checklist: checklist,
      }
    end

    def authorized?(checklist:, title: '')
      Pundit.authorize(context.current_user, checklist.ticket, :update?)
    end
  end
end
