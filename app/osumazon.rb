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

  until logged_out
    choice = prompt.select("What would you like to do? ", options)
    case choice
      when "Shop"
        shop
      when "Checkout"
        if $cart.empty?
          puts "Your cart is empty."
          puts "Go get some shit!"
        else
          review_cart
          if $cart.empty?
            puts "Your cart is empty."
            puts "Go get some shit!"
          else
            checkout
          end
        end
      when "Logout"
        puts "You are logged out."
        $current_user = nil
        $cart = []
        logged_out = true
      when "Settings"
        settings
        $current_user = nil
        $cart = []
        logged_out = true
    end
  end
end

def checkout
  sum = 0.0
  $cart.each do |item|
    sum += item.price
  end
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
      if prompt.select('Add to cart?', ["Yes", "No"]) == "Yes"
        add_to_cart(product)
        complete = true
      else
        puts "Have fun!"
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

def settings
  exit = false
  options = ["exit", "Change Password", "Delete Account"]
  prompt = TTY::Prompt.new

  until exit
    option = prompt.select("Select from the following: ", options)
    case option
    when "Change Password"
      print "Enter new password: "
      password = gets.chomp
      $current_user.password = password
      $current_user.save
      puts "Password updated."
    when "Delete Account"
      if prompt.select('Are you sure you want to delete your account?', ["Yes", "No"]) == "Yes"
        $current_user.destroy
        exit = true
        puts "Sorry to see you go! :("
      end
    when "exit"
      exit = true
    end
  end
end
