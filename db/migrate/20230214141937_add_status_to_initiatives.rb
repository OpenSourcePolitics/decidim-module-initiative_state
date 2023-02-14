class AddStatusToInitiatives < ActiveRecord::Migration[6.1]
  def change
    add_reference :decidim_initiatives, :decidim_status, index: true
  end
end
