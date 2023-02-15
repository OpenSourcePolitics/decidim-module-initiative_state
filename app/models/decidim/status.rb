# frozen_string_literal: true

module Decidim
  # Statuses are used in Initiatives to help users know which is
  # the status of a participatory space.
  class Status < ApplicationRecord
    include Traceable
    include Loggable
    include Decidim::TranslatableResource

    translatable_fields :name

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization",
               inverse_of: :statuses

    validates :name, presence: true, uniqueness: { scope: :organization }

    before_destroy :abort_if_dependencies

    def self.log_presenter_class_for(_log)
      Decidim::AdminLog::StatusPresenter
    end

    def translated_name
      Decidim::StatusPresenter.new(self).translated_name
    end

    def has_dependencies?
      Decidim.participatory_space_registry.manifests.any? do |manifest|
        manifest
          .participatory_spaces
          .call(organization)
          .any? do |space|
          space.respond_to?(:status) && space.decidim_status_id == id
        end
      end
    end

    # used on before_destroy
    def abort_if_dependencies
      throw(:abort) if has_dependencies?
    end
  end
end
