class CreateFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :features do |t|
      t.string :name
      t.string :code
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
