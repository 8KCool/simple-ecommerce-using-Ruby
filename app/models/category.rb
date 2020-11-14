class Category < ApplicationRecord
  include NameSearchable

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories
end
