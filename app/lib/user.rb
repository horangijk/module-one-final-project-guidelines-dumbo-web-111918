class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions



  def shop
    categories = Electronic.categories
    prompt = TTY::Prompt.new
    category = prompt.enum_select("Select from the following: ", categories)
    product_names = Electronic.where(category: category).map {|p| p.name}
    product_name = prompt.enum_select("Select from the following: ", product_names)
    Electronic.find_by(name: product_name)
  end
end
