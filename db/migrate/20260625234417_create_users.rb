class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :username
      t.string :avatar_url
      t.boolean :onboarding_complete
      t.string :timezone
      t.string :units
      t.boolean :public_profile

      t.timestamps
    end
  end
end
