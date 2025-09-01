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

  # Prefer nickname for public display (avoid leaking real name by default)
  def display_name
    nickname.presence || email.to_s.split('@').first.presence || masked_fallback
  end

  # Generate a default nickname if blank on creation
  before_validation :ensure_nickname, on: :create
  validates :nickname, length: { maximum: 30 }, uniqueness: { allow_nil: true, allow_blank: true }

  private

  def ensure_nickname
    return if nickname.present?

    base = email.to_s.split('@').first.presence || '사용자'
    base = base.gsub(/[^0-9A-Za-z가-힣_-]/, '')
    candidate = base
    suffix = 0
    while User.where.not(id: id).exists?(nickname: candidate)
      suffix += 1
      candidate = "#{base}-#{SecureRandom.alphanumeric(4).downcase}"
      break if suffix > 5
    end
    self.nickname = candidate
  end

  def masked_fallback
    "사용자-#{SecureRandom.alphanumeric(6).downcase}"
  end
end
