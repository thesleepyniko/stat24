class AddUniqueIndexToUsers < ActiveRecord::Migration[8.1]
  def change
    add_index :users, [ :provider, :uid ], unique: true
  end
end
