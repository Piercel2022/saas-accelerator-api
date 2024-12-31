class BillingPlan < ApplicationRecord
  has_many :features
  has_many :subscriptions
  
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :interval, inclusion: { in: %w[monthly yearly] }
  
  def self.compare(plan_ids)
    where(id: plan_ids).includes(:features)
  end
end
