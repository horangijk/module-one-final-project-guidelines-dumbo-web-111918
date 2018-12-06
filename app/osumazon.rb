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
      system "clear"
      puts "Exiting!"
      sleep(1)

    else
      current_user = User.find_by(username: username)
      if current_user
        system "clear"
        password = prompt.mask("Type in your password: ")
        logged_in = current_user.password == password
        if logged_in
          puts "Welcome to Osumazon!"
        else
          puts "Wrong password"
        end
        $current_user = current_user
      else
        system "clear"
        puts "Invalid username."
      end
    end
  end
  logged_in
end

def create_account
  prompt = TTY::Prompt.new
  created = false
  until created
    puts "Enter your new username (Can’t be 'exit'): "
    username = gets.chomp
    if username == "exit"
      if prompt.select("Are you sure you want to exit?", ["Yes", "No"]) == "Yes"
        system "clear"
        created = true
      else
        system "clear"
        puts "We told you, it can’t be 'exit'"
      end
    elsif !User.find_by(username: username)
      password = prompt.mask("Type in your password: ")
      User.create(username: username, password: password)
      puts "Your new account details. Username: #{username}, Password: #{password}."
      created = true
    else
      system "clear"
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
  indices_to_delete = prompt.multi_select("Press 'SPACE' to choose items to remove. Press 'ENTER' to continue.", choices)
  indices_to_delete.each do |index|
    if prompt.select("Are you sure you want to delete #{$cart[index].name}?", ["Yes", "No"]) == "Yes"
      puts "Deleted #{$cart[index].name}."
      $cart.delete_at(index)
    end
  end
end

def menu
  prompt = TTY::Prompt.new
  options = ["Shop", "Checkout", "Prior Purchases", "Settings", "Logout"]
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
    when "Prior Purchases"
      system "clear"
      $current_user.display_transactions
      system "clear"
    end
  end
end

def logout
  system "clear"
  puts "You are logged out."
  sleep(1)
  $current_user = nil
  $cart = []
end

def checkout
  sum = 0.0
  $cart.each do |item|
    sum += item.price
  end
  system "clear"
  puts "Your cart is $#{'%.2f' % sum}."
  prompt = TTY::Prompt.new
  if prompt.select("Do you wish to checkout?", ["Yes", "No"]) == "Yes"
    $cart.each do |item|
      new_trans = Transaction.find_or_create_by(user_id: $current_user.id , electronic_id: item.id)
      new_trans.quantity ||= 0
      new_trans.quantity += 1
      new_trans.save
    end
    $cart = []
    puts "You spent $#{'%.2f' % (sum * 1.08875)}."
    sleep(1)
    print "Press any key to continue: "
    STDIN.getch
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
        product = Electronic.find_by(name: product_name)
        print "$#{'%.2f' % product.price} "
        if prompt.select('Add to cart?', ["Yes", "No"]) == "Yes"
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
      $current_user.change_password
    when "Delete Account"
      if $current_user.delete_account
        logout
      end
    when "exit"
      completed = true
    end
  end
end
