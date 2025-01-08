class CreateBillingPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_plans do |t|
      t.string :name
      t.decimal :price
      t.string :interval
      t.jsonb :features
      t.string :status

      t.timestamps
    end
  end
end
