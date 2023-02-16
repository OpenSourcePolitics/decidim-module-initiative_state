# frozen_string_literal: true

module PermissionsExtends
  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity
  def permissions
    return permission_action if managed_user_action?

    unless permission_action.scope == :admin
      read_admin_dashboard_action?
      return permission_action
    end

    unless user
      disallow!
      return permission_action
    end

    if user_manager?
      begin
        allow! if user_manager_permissions.allowed?
      rescue Decidim::PermissionAction::PermissionNotSetError
        nil
      end
    end

    allow! if user_can_enter_space_area?(require_admin_terms_accepted: true)

    read_admin_dashboard_action?
    apply_newsletter_permissions_for_admin!

    allow! if permission_action.subject == :global_moderation && admin_terms_accepted?

    if user.admin? && admin_terms_accepted?
      allow! if read_admin_log_action?
      allow! if read_user_statistics_action?
      allow! if read_metrics_action?
      allow! if static_page_action?
      allow! if templates_action?
      allow! if organization_action?
      allow! if user_action?

      allow! if permission_action.subject == :category
      allow! if permission_action.subject == :component
      allow! if permission_action.subject == :admin_user
      allow! if permission_action.subject == :attachment
      allow! if permission_action.subject == :editor_image
      allow! if permission_action.subject == :attachment_collection
      allow! if permission_action.subject == :scope
      allow! if permission_action.subject == :scope_type
      allow! if permission_action.subject == :status
      allow! if permission_action.subject == :area
      allow! if permission_action.subject == :area_type
      allow! if permission_action.subject == :user_group
      allow! if permission_action.subject == :officialization
      allow! if permission_action.subject == :moderate_users
      allow! if permission_action.subject == :authorization
      allow! if permission_action.subject == :authorization_workflow
      allow! if permission_action.subject == :static_page_topic
      allow! if permission_action.subject == :help_sections
      allow! if permission_action.subject == :share_token
      allow! if permission_action.subject == :reminder
    end

    permission_action
  end
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/PerceivedComplexity
end
