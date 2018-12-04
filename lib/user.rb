class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions
end
