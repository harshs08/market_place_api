class Order < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements
  
  validates :user_id, presence: true

  before_validation :set_total!

  def set_total!
    self.total = products.map(&:price).sum
  end

end
