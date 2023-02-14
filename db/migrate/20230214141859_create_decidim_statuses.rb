class CreateDecidimStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_statuses do |t|
      t.jsonb :name
      t.references :decidim_organization, foreign_key: true, index: true
      t.timestamps
    end
  end
end
