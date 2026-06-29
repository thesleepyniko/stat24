class RenameUserSessionTokenCol < ActiveRecord::Migration[8.1]
  def change
    rename_column :user_sessions, :token, :token_digest
  end
end
