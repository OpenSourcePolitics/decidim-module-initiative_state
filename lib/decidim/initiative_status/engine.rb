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
