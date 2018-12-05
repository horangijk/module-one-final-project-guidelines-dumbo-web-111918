$current_user = nil
$cart = []

def login
  logged_in = false
  exit = false
  until logged_in || exit
    puts "Enter your username, or type 'exit': "
    username = STDIN.gets.chomp
    if username == 'exit'
      exit = true
      puts "Exiting!"
    else
      current_user = User.find_by(username: username)
      if current_user
        puts "Enter your password. "
        password = STDIN.gets.chomp
        logged_in = current_user.password == password
        if logged_in
          puts "Welcome to Osumazon!"
        else
          puts "Wrong password"
        end
        $current_user = current_user
      else
        puts "Invalid username."
      end
    end
  end
  logged_in
end

def create_account
  created = false
  until created
    puts "Enter your new username (Can’t be 'exit'): "
    username = STDIN.gets.chomp
    if !User.find_by(username: username)
      puts "Enter your new password: "
      password = STDIN.gets.chomp
      User.create(username: username, password: password)
      puts "Your new account details. Username: #{username}, Password: #{password}."
      created = true
    else
      puts "Username already chosen!"
    end
  end
end

def add_to_cart(product)
  $cart << product
end

def cart
  $cart
end

def menu
  prompt = TTY::Prompt.new
  menu = ["Shop", "Checkout", "Logout"]

  logged_out = false
  until logged_out
    choice = prompt.select("What would you like to do? ", menu)
    case choice
    when "Shop"
      shop

    when "Checkout"
      checkout
    when "Logout"
      puts "You are logged out."
      $current_user = nil
      $cart = []
      logged_out = true
    end
  end
end

def checkout
  if $cart.empty?
    puts "Your cart is empty."
    puts "Go get some shit!"
  else
    sum = 0.0
    $cart.each do |item|
      sum += item.price
    end
    puts "Your cart is $#{sum}."
    prompt = TTY::Prompt.new
    if prompt.yes?("Do you wish to checkout?")
      $cart.each do |item|
        new_trans = Transaction.find_or_create_by(user_id: $current_user.id , electronic_id: item.id)
        new_trans.quantity ||= 0
        new_trans.quantity += 1
        new_trans.save
      end
      $cart = []
      puts "You spent $#{sum}."
    else
      puts "Okay, bye!"
    end
  end
end

def shop
  complete = false
  categories = Electronic.categories
  categories << "exit"
  prompt = TTY::Prompt.new

  until complete
    category = prompt.select("Select from the following: ", categories)
    product_names = Electronic.where(category: category).map {|p| p.name}
    if category == "exit"
      complete = true
    else
      product_name = prompt.select("Select from the following: ", product_names)
      product = Electronic.find_by(name: product_name)
      if prompt.yes?('Add to cart?')
        add_to_cart(product)
        complete = true
      end
      category = nil
      product_name = nil
    end
  end


end

def start
  quit = false
  choices = ["Login", "Create Account", "Quit"]
  prompt = TTY::Prompt.new
  until quit
    choice = prompt.select("Welcome to Osumazon! What would you like to do?", choices)
    case choice
    when "Login"
      if login
        menu
      end
    when "Create Account"
      create_account
    when "Quit"
      puts "Bye bye from Osumazon!"
      quit = true
    end
  end
end
