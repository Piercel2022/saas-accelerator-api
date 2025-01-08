# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
require 'faker'

# Clear existing data
puts "Cleaning database..."
ActivityLog.destroy_all
Notification.destroy_all
Subscription.destroy_all
BillingPlanFeature.destroy_all
Feature.destroy_all
BillingPlan.destroy_all
User.destroy_all
Organization.destroy_all

puts "Creating features..."
features = [
  { name: 'Team Members', code: 'team_members', description: 'Number of team members allowed', status: 'active' },
  { name: 'Storage Space', code: 'storage_space', description: 'Available storage in GB', status: 'active' },
  { name: 'Custom Domain', code: 'custom_domain', description: 'Use your own domain name', status: 'active' },
  { name: 'API Access', code: 'api_access', description: 'Access to our API', status: 'active' },
  { name: 'Priority Support', code: 'priority_support', description: '24/7 priority support', status: 'active' },
  { name: 'Analytics', code: 'analytics', description: 'Advanced analytics and reporting', status: 'active' },
  { name: 'White Label', code: 'white_label', description: 'Remove our branding', status: 'active' },
  { name: 'Audit Logs', code: 'audit_logs', description: 'Detailed audit logs', status: 'active' }
].map do |feature|
  Feature.create!(feature)
end

puts "Creating billing plans..."
billing_plans = [
  {
    name: 'Free',
    price: 0,
    interval: 'monthly',
    features: {
      team_members: '2',
      storage_space: '1',
      custom_domain: 'false',
      api_access: 'false',
      priority_support: 'false',
      analytics: 'basic',
      white_label: 'false',
      audit_logs: 'false'
    },
    status: 'active'
  },
  {
    name: 'Startup',
    price: 29.99,
    interval: 'monthly',
    features: {
      team_members: '5',
      storage_space: '10',
      custom_domain: 'true',
      api_access: 'true',
      priority_support: 'false',
      analytics: 'basic',
      white_label: 'false',
      audit_logs: 'true'
    },
    status: 'active'
  },
  {
    name: 'Business',
    price: 99.99,
    interval: 'monthly',
    features: {
      team_members: '20',
      storage_space: '50',
      custom_domain: 'true',
      api_access: 'true',
      priority_support: 'true',
      analytics: 'advanced',
      white_label: 'true',
      audit_logs: 'true'
    },
    status: 'active'
  },
  {
    name: 'Enterprise',
    price: 299.99,
    interval: 'monthly',
    features: {
      team_members: 'unlimited',
      storage_space: '500',
      custom_domain: 'true',
      api_access: 'true',
      priority_support: 'true',
      analytics: 'advanced',
      white_label: 'true',
      audit_logs: 'true'
    },
    status: 'active'
  }
].map do |plan|
  bp = BillingPlan.create!(
    name: plan[:name],
    price: plan[:price],
    interval: plan[:interval],
    status: plan[:status]
  )
  
  # Create BillingPlanFeature records
  plan[:features].each do |feature_code, value|
    feature = features.find { |f| f.code == feature_code.to_s }
    BillingPlanFeature.create!(
      billing_plan: bp,
      feature: feature,
      value: value
    )
  end
  bp
end

puts "Creating organizations..."
10.times do |i|
  company_name = Faker::Company.unique.name
  organization = Organization.create!(
    name: company_name,
    subdomain: company_name.parameterize,
    member_limit: [5, 10, 20, 50].sample,
    status: 'active'
  )
  
  # Create admin user for organization
  admin = User.create!(
    email: "admin_#{i}@#{organization.subdomain}.example.com",
    password: 'password123',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: 'admin',
    organization: organization
  )
  
  # Create regular users for organization
  rand(2..5).times do
    User.create!(
      email: Faker::Internet.email(domain: "#{organization.subdomain}.example.com"),
      password: 'password123',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      role: 'member',
      organization: organization
    )
  end
  
  # Create subscription
  subscription_status = ['active', 'active', 'active', 'past_due', 'canceled'].sample
  subscription = Subscription.create!(
    organization: organization,
    billing_plan: billing_plans.sample,
    status: subscription_status,
    start_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
    end_date: Faker::Date.between(from: Date.today, to: 1.year.from_now)
  )
  
  # Create notifications for users
  organization.users.each do |user|
    rand(1..3).times do
      Notification.create!(
        user: user,
        title: Faker::Company.catch_phrase,
        message: Faker::Company.bs,
        status: ['unread', 'read'].sample,
        read_at: ['read'].sample ? Faker::Time.between(from: 1.days.ago, to: Time.now) : nil
      )
    end
  end
  
  # Create activity logs
  10.times do
    ActivityLog.create!(
      user: organization.users.sample,
      organization: organization,
      action: ['created', 'updated', 'deleted', 'accessed'].sample,
      resource_type: ['Document', 'Project', 'Setting', 'User'].sample,
      resource_id: rand(1..100),
      details: {
        ip_address: Faker::Internet.ip_v4_address,
        user_agent: Faker::Internet.user_agent,
        changes: {
          before: { status: 'draft' },
          after: { status: 'published' }
        }
      }
    )
  end
end

puts "Seed completed successfully!"
puts "Created:"
puts "- #{Feature.count} features"
puts "- #{BillingPlan.count} billing plans"
puts "- #{Organization.count} organizations"
puts "- #{User.count} users"
puts "- #{Subscription.count} subscriptions"
puts "- #{Notification.count} notifications"
puts "- #{ActivityLog.count} activity logs"