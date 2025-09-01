class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :likes, dependent: :destroy

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.name  = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      user.save!
    end
  end

  def liked?(record)
    return false unless record
    likes.exists?(likeable: record)
  end
end
