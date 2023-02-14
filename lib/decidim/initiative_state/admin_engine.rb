# frozen_string_literal: true

module Decidim
  module InitiativeState
    # This is the engine that runs on the public interface of `InitiativeState`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::InitiativeState::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :initiative_state do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "initiative_state#index"
      end

      def load_seed
        nil
      end
    end
  end
end
