class CreateActivityLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :action
      t.string :resource_type
      t.integer :resource_id
      t.jsonb :details

      t.timestamps
    end
  end
end
