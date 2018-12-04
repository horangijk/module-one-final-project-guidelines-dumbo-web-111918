class Electronic < ActiveRecord::Base
  has_many :transactions
  has_many :users, through: :transactions

  def self.categories
    Electronic.all.map {|electronic| electronic.category }
  end
end
