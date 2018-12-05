class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions

  def shop
    categories = Electronic.categories
    prompt = TTY::Prompt.new
    category = prompt.enum_select("Select from the following: ", categories)
    Electronic.where(category: category)

  end
end
