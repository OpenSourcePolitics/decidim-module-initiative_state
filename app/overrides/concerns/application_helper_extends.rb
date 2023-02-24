# frozen_string_literal: true

module ApplicationHelperExtends
  include Decidim::CheckBoxesTreeHelper

  def filter_statuses_values
    TreeNode.new(
      TreePoint.new("", t("decidim.initiatives.application_helper.filter_status_values.all")),
      filter_statuses(current_organization.statuses)
    )
  end

  def filter_statuses(statuses)
    statuses.map do |status|
      TreeNode.new(
        TreePoint.new(status.id.to_s, status.translated_name)
      )
    end
  end
end
