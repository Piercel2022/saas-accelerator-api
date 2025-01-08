class CreateBillingPlanFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_plan_features do |t|
      t.references :billing_plan, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
