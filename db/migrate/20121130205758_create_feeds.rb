class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.text :entry
      t.string :entry_id
      t.string :status_type
      t.string :entry_type

      t.timestamps
    end
  end
end
