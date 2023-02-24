# frozen_string_literal: true

module InitiativesControllerExtends
  private

  def default_filter_params
    {
      search_text_cont: "",
      with_any_state: %w(open),
      with_any_type: default_filter_type_params,
      author: "any",
      with_any_scope: default_filter_scope_params,
      with_any_area: default_filter_area_params,
      with_any_status: default_filter_status_params
    }
  end

  def default_filter_status_params
    %w(all) + current_organization.statuses.pluck(:id).map(&:to_s)
  end
end
