# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module InitiativeStatus
    # This is the engine that runs on the public interface of initiative_status.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::InitiativeStatus

      routes do
        # Add engine routes here
        # resources :initiative_status
        # root to: "initiative_status#index"
      end

      initializer "InitiativeStatus.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "InitiativeStatus.mount_routes" do
        Decidim::Admin::Engine.routes.prepend do
          resources :statuses, except: [:show]
        end
      end

      initializer "InitiativeStatus.add_cells_view_paths" do
        Cell::ViewModel.view_paths.unshift(File.expand_path("#{Decidim::InitiativeStatus::Engine.root}/app/cells"))
        Cell::ViewModel.view_paths.unshift(File.expand_path("#{Decidim::InitiativeStatus::Engine.root}/app/views")) # for partials
      end

      initializer "initiative_status.overrides" do
        config.to_prepare do
          Decidim::Initiatives::Admin::UpdateInitiative.class_eval do
            prepend(UpdateInitiativeExtends)
          end

          Decidim::Initiatives::InitiativesController.class_eval do
            prepend(InitiativesControllerExtends)
          end

          Decidim::Initiatives::Admin::InitiativeForm.class_eval do
            include(InitiativeFormExtends)
          end

          Decidim::Initiatives::ApplicationHelper.class_eval do
            prepend(ApplicationHelperExtends)
          end

          Decidim::Initiative.class_eval do
            include(InitiativeExtends)
          end

          Decidim::Organization.class_eval do
            include(OrganizationExtends)
          end

          Decidim::Admin::Permissions.class_eval do
            prepend(PermissionsExtends)
          end
        end
      end

      initializer "InitiativeStatus.admin_settings_menu" do
        Decidim.menu :admin_settings_menu do |menu|
          menu.add_item :statuses,
                        I18n.t("menu.statuses", scope: "decidim.admin"),
                        decidim_admin.statuses_path,
                        position: 1.7,
                        if: allowed_to?(:read, :status),
                        active: is_active_link?(decidim_admin.statuses_path)
        end
      end
    end
  end
end
