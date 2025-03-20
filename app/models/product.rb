class Product < ApplicationRecord
    has_many :order_items, dependent: :destroy
    has_many :orders, through: :order_items

    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
