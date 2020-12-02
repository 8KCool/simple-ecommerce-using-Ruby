class License < ApplicationRecord
  include Paginatable

  belongs_to :game
  belongs_to :user, optional: true

  validates :key, presence: true, uniqueness: { case_sensitive: true }
end
