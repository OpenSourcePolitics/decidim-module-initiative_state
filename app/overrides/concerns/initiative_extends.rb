# frozen_string_literal: true

module InitiativeExtends
  extend ActiveSupport::Concern

  included do
    belongs_to :status,
               foreign_key: "decidim_status_id",
               class_name: "Decidim::Status",
               optional: true

    scope :with_any_status, lambda { |*original_status_ids|
      status_ids = original_status_ids.map { |id| id.to_s.split("_") }.flatten.uniq
      return self if status_ids.include?("all")

      where(decidim_status_id: status_ids)
    }

    def self.ransackable_scopes(_auth_object = nil)
      [:with_any_state, :with_any_status, :with_any_type, :with_any_scope, :with_any_area]
    end
  end
end
