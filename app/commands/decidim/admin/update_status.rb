# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when updating a status.
    class UpdateStatus < Decidim::Command
      # Public: Initializes the command.
      #
      # status - The Status to update
      # form - A form object with the params.
      def initialize(status, form)
        @status = status
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        update_status
        broadcast(:ok)
      end

      private

      attr_reader :form

      def update_status
        Decidim.traceability.update!(
          @status,
          form.current_user,
          attributes
        )
      end

      def attributes
        {
          name: form.name
        }
      end
    end
  end
end
