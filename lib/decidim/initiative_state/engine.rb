# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module InitiativeState
    # This is the engine that runs on the public interface of initiative_state.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::InitiativeState

      routes do
        # Add engine routes here
        # resources :initiative_state
        # root to: "initiative_state#index"
      end

      initializer "InitiativeState.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
