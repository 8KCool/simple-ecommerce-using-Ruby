class License < ApplicationRecord
  include Paginatable

  belongs_to :game
  belongs_to :user

  validates :key, presence: true, uniqueness: { case_sensitive: true }
end
