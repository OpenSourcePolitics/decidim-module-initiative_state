# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic to destroy a status.
    class DestroyStatus < Decidim::Command
      # Public: Initializes the command.
      #
      # status - The status to destroy
      # current_user - the user performing the action
      def initialize(status, current_user)
        @status = status
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        destroy_status
        broadcast(:ok)
      rescue ActiveRecord::RecordNotDestroyed
        broadcast(:has_spaces)
      end

      private

      attr_reader :current_user

      def destroy_status
        Decidim.traceability.perform_action!(
          "delete",
          @status,
          current_user
        ) do
          @status.destroy!
        end
      end
    end
  end
end
