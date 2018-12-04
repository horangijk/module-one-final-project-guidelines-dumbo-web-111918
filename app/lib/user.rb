class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions



  def shop
    complete = false
    categories = Electronic.categories
    prompt = TTY::Prompt.new

    until complete
      category = prompt.enum_select("Select from the following: ", categories)
      product_names = Electronic.where(category: category).map {|p| p.name}
      product_name = prompt.enum_select("Select from the following: ", product_names)
      product = Electronic.find_by(name: product_name)
      if prompt.yes?('Add to cart?')
        add_to_cart(product)
        complete = true
      end
    end 


  end


end
