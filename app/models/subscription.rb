class Subscription < ApplicationRecord
  belongs_to :organization
  belongs_to :billing_plan
end
