# frozen_string_literal: true

module Decidim
  module Admin
    # A form object to create or update statuses.
    class StatusForm < Form
      include TranslatableAttributes

      translatable_attribute :name, String
      attribute :organization, Decidim::Organization

      mimic :status

      validates :name, translatable_presence: true
      validates :organization, presence: true

      validate :name_uniqueness

      def name_uniqueness
        return unless organization
        return unless organization.statuses.where(name: name).where.not(id: id).any?

        errors.add(:name, :taken)
      end

      alias organization current_organization
    end
  end
end
