class Subscription < ApplicationRecord
  #include Broadcastable
  
  belongs_to :organization
  belongs_to :billing_plan

  after_commit :notify_status_change, on: [:create, :update]

  private

  def notify_status_change
    return unless saved_change_to_status?

    ActionCable.server.broadcast(
      "organization_#{organization_id}",
      {
        type: 'subscription_status',
        action: 'updated',
        data: {
          id: id,
          status: status,
          message: "Subscription status changed to #{status}"
        }
      }
    )
  end
end
