# frozen_string_literal: true

module InitiativeFormExtends
  extend ActiveSupport::Concern

  included do
    attribute :status_id, Integer

    def status
      @status ||= current_organization.statuses.find_by(id: status_id)
    end
  end
end
