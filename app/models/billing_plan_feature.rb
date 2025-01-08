class BillingPlanFeature < ApplicationRecord
  belongs_to :billing_plan
  belongs_to :feature
end
