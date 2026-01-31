class Compilation < ApplicationRecord
  belongs_to :user

  validates :input_text, presence: true
  validates :output_text, presence: true
end
