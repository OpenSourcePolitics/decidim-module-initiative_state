# frozen_string_literal: true

module OrganizationExtends
  extend ActiveSupport::Concern

  included do
    has_many :statuses, -> { order(name: :asc) }, foreign_key: "decidim_organization_id", class_name: "Decidim::Status", inverse_of: :organization, dependent: :destroy
  end
end
