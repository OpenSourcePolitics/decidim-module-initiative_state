# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing all statuses at the admin panel.
    #
    class StatusesController < Decidim::Admin::ApplicationController
      layout "decidim/admin/settings"
      helper_method :statuses, :organization_statuses

      def index
        enforce_permission_to :read, :status
        @statuses = organization_statuses
      end

      def new
        enforce_permission_to :create, :status
        @form = form(StatusForm).instance
      end

      def create
        enforce_permission_to :create, :status
        @form = form(StatusForm).from_params(params)
        CreateStatus.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("statuses.create.success", scope: "decidim.admin")
            redirect_to statuses_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("statuses.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      def edit
        enforce_permission_to :update, :status, status: status
        @form = form(StatusForm).from_model(status)
      end

      def update
        enforce_permission_to :update, :status, status: status
        @form = form(StatusForm).from_params(params)

        UpdateStatus.call(status, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("statuses.update.success", scope: "decidim.admin")
            redirect_to statuses_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("statuses.update.error", scope: "decidim.admin")
            render :edit
          end
        end
      end

      def destroy
        enforce_permission_to :destroy, :status, status: status

        DestroyStatus.call(status, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("statuses.destroy.success", scope: "decidim.admin")
            redirect_to statuses_path
          end
          on(:has_spaces) do
            flash[:alert] = I18n.t("statuses.destroy.has_spaces", scope: "decidim.admin")
            redirect_to statuses_path
          end
        end
      end

      private

      def organization_statuses
          @organization_statuses ||= current_organization.statuses
      end
        current_organization.statuses
      end

      def status
        return @status if defined?(@status)

        @status = organization_statuses.find_by(id: params[:id])
      end
    end
  end
end
