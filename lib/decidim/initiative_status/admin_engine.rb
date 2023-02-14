# frozen_string_literal: true

module Decidim
  module InitiativeStatus
    # This is the engine that runs on the public interface of `InitiativeStatus`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::InitiativeStatus::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :initiative_status do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "initiative_status#index"
      end

      def load_seed
        nil
      end
    end
  end
end
