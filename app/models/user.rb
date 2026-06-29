class User < ApplicationRecord
  enum :role, { pilot: 0, atc: 1, observer: 2 }
  enum :access_level, { member: 0, admin: 1 }
  enum :referral, { resources: 0, friend: 1, search: 2, other: 3 } # resources = the resources channel on the discord

  validates :uid, uniqueness: { scope: :provider }
  has_many :user_sessions, dependent: :destroy
end
