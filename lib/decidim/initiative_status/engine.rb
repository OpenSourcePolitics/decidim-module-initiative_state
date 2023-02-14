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
    end
  end
end
