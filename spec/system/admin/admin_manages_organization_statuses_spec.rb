# frozen_string_literal: true

require "spec_helper"

describe "Organization Statuses", type: :system do
  include Decidim::SanitizeHelper

  let(:admin) { create :user, :admin, :confirmed }
  let(:organization) { admin.organization }

  before do
    switch_to_host(organization.host)
  end

  describe "Managing statuses" do
    before do
      login_as admin, scope: :user
      visit decidim_admin.root_path
      click_link "Settings"
      click_link "Statuses"
    end

    it "can create new status" do
      click_link "Add"

      within ".new_status" do
        fill_in_i18n :status_name, "#status-name-tabs", en: "My status",
                                                        es: "Mi statut",
                                                        ca: "La meva statut"

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within "table" do
        expect(page).to have_content("My status")
      end
    end

    context "with existing statuses" do
      let!(:status) { create(:status, organization: organization) }

      before do
        visit current_path
      end

      it "lists all the statuses for the organization" do
        within "#statuses table" do
          expect(page).to have_content(translated(status.name, locale: :en))
        end
      end

      it "can edit them" do
        within find("tr", text: translated(status.name)) do
          click_link "Edit"
        end

        within ".edit_status" do
          fill_in_i18n :status_name, "#status-name-tabs", en: "Another status",
                                                          es: "Otra statut",
                                                          ca: "Una altra statut"
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")

        within "table" do
          expect(page).to have_content("Another status")
        end
      end

      it "can delete them" do
        click_delete_status

        expect(page).to have_admin_callout("successfully")

        within ".card-section" do
          expect(page).to have_no_content(translated(status.name))
        end
      end

      context "when an initiative associated to a given status exist" do
        let!(:initiative) { create(:initiative, organization: status.organization, status: status) }

        it "can not be deleted" do
          click_delete_status
          expect(status.reload.destroyed?).to be false
          expect(page).to have_admin_callout("This status has dependent initiatives")
        end
      end
    end
  end

  private

  def click_delete_status
    within find("tr", text: translated(status.name)) do
      accept_confirm { click_link "Delete" }
    end
  end
end
