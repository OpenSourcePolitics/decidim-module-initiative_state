# frozen_string_literal: true

module InitiativesAdminControllerExtends
  extend ActiveSupport::Concern

  included do
    private

    def filters
      [:state_eq, :type_id_eq, :decidim_area_id_eq, :status_id_eq]
    end

    def filters_with_values
      {
        state_eq: Decidim::Initiative.states.keys,
        type_id_eq: Decidim::InitiativesType.where(organization: current_organization).pluck(:id),
        decidim_area_id_eq: current_organization.areas.pluck(:id),
        status_id_eq: current_organization.statuses.pluck(:id)
      }
    end

    def dynamically_translated_filters
      [:type_id_eq, :decidim_area_id_eq, :status_id_eq]
    end

    def translated_status_id_eq(id)
      translated_attribute(Decidim::Status.find_by(id: id).name[I18n.locale.to_s])
    end
  end
end
