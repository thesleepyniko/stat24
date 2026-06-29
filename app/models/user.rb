class User < ApplicationRecord
  validates :uid, uniqueness: { scope: :provider }
  has_many :user_sessions, dependent: :destroy
end
