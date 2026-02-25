class Compilation < ApplicationRecord
  belongs_to :user

  validates :input_text, presence: true
  validates :output_text, presence: true

  def expired?(ttl: 30.days)
    created_at < ttl.ago
  end

  def expires_at(ttl: 30.days)
    created_at + ttl
  end
end
