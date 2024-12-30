class Organization < ApplicationRecord
    include Broadcastable
    
    has_many :users
    has_many :subscriptions
    
    validates :name, presence: true
    validates :subdomain, presence: true, uniqueness: true
  
    after_commit :broadcast_member_update, on: [:update]
  
    private
  
    def broadcast_member_update
      return unless saved_change_to_member_limit?
  
      users.each do |user|
        ActionCable.server.broadcast(
          "user_#{user.id}",
          {
            type: 'organization_update',
            action: 'member_limit_changed',
            data: {
              member_limit: member_limit,
              current_members: users.count
            }
          }
        )
      end
    end
  end