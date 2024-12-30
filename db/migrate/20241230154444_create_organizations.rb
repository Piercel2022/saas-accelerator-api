class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :subdomain
      t.integer :member_limit
      t.string :status

      t.timestamps
    end
  end
end
