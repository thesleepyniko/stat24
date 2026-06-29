class AddRoleAndConsentAndReferralToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :integer
    add_column :users, :access_level, :integer, default: 0, null: false
    add_column :users, :consent, :boolean, default: false, null: false
    add_column :users, :referral, :integer
  end
end
