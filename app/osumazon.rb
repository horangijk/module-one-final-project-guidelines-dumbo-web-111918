$current_user = nil
$cart = []

def login
  prompt = TTY::Prompt.new
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
        password = prompt.mask("Type in your password: ")
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
    username = gets.chomp
    if username == "exit"
      puts "We told you, it can’t be 'exit'"
    elsif !User.find_by(username: username)
      password = prompt.mask("Type in your password: ")
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

def review_cart
  choices = {}
  $cart.each_with_index do |item, i|
    choices["#{i+1}. #{item.name}"] = i
  end
  prompt = TTY::Prompt.new
  indices_to_delete = prompt.multi_select("Choose items to delete: ", choices)
  indices_to_delete.each do |index|
    if prompt.select("Are you sure you want to delete #{$cart[index].name}?", ["Yes", "No"]) == "Yes"
      puts "Deleted #{$cart[index].name}."
      $cart.delete_at(index)
    end
  end
end

def menu
  prompt = TTY::Prompt.new
  options = ["Shop", "Checkout", "Logout", "Settings"]
  logged_out = false

  while $current_user
    choice = prompt.select("What would you like to do? ", options)
    case choice
    when "Shop"
      system "clear"
      shop
      system "clear"
    when "Checkout"
      system "clear"
      if $cart.empty?
        puts "Your cart is empty."
        puts "Go get some shit!"
      else
        system "clear"
        review_cart
        system "clear"
        if $cart.empty?
          puts "Your cart is empty."
          puts "Go get some shit!"
        else
          checkout
          system "clear"
        end
      end
    when "Logout"
      system "clear"
      logout
      system "clear"
    when "Settings"
      system "clear"
      settings
      system "clear"
    end
  end
end

def logout
  system "clear"
  puts "You are logged out."
  $current_user = nil
  $cart = []
end

def checkout
  sum = 0.0
  $cart.each do |item|
    sum += item.price
  end
  system "clear"
  puts "Your cart is $#{sum}."
  prompt = TTY::Prompt.new
  if prompt.select("Do you wish to checkout?", ["Yes", "No"]) == "Yes"
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

def shop
  complete = false
  categories = Electronic.categories.uniq
  categories << "exit"
  prompt = TTY::Prompt.new

  until complete
    system "clear"
    category = prompt.select("Select a category: ", categories)
    if category == "exit"
      complete = true
    else
      product_names = Electronic.where(category: category).map {|p| p.name}
      product_names << "exit"
      product_name = prompt.select("Select an item: ", product_names)
      if product_name != "exit"
        if prompt.select('Add to cart?', ["Yes", "No"]) == "Yes"
          product = Electronic.find_by(name: product_name)
          add_to_cart(product)
        end
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
    system "clear"
    choice = prompt.select("Welcome to Osumazon! What would you like to do?", choices)
    case choice
    when "Login"
      system "clear"
      if login
        system "clear"
        menu
      end
    when "Create Account"
      create_account
    when "Quit"
      system "clear"
      puts "Bye bye from Osumazon!"
      quit = true
    end
  end
end

def settings
  prompt = TTY::Prompt.new
  completed = false
  options = ["exit", "Change Password", "Delete Account"]
  until completed || !$current_user
    system "clear"
    option = prompt.select("Select from the following: ", options)
    case option
    when "Change Password"
      change_password
    when "Delete Account"
      delete_account
    when "exit"
      completed = true
    end
  end
end

def delete_account
  prompt = TTY::Prompt.new
  deleted = false
  until deleted
    if prompt.select('Are you sure you want to delete your account?', ["Yes", "No"]) == "Yes"
      delete_account_password = prompt.mask("Type in your password: ")
      if delete_account_password == $current_user.password
        $current_user.destroy
        exit = true
        puts "Sorry to see you go! :("
        deleted = true
        $current_user = nil
      else
        puts "Wrong password. Please type in your password."
        deleted = false
      end
    else
      deleted = true
    end
  end
end

def change_password
  prompt = TTY::Prompt.new
  if prompt.select('Are you sure you want to update your password?', ["Yes", "No"]) == "Yes"
    password = prompt.mask("Type in your new password: ")
    $current_user.password = password
    $current_user.save
    puts "Password updated."
    puts "You are logged out."
    $current_user = nil
  end
end
