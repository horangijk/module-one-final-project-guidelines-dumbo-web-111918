
class App
  @@current_user = nil
  @@cart = []
  @@prompt = TTY::Prompt.new

  def self.invalid_cart_message
    puts "Your cart is empty."
    puts "Go get some shit!"
  end

  def self.login
    done = false
    until @@current_user || done
      puts "Enter your username, or type 'exit': "
      username = STDIN.gets.chomp
      if username == 'exit'
        done = true
        system "clear"
        puts "Exiting!"
        sleep(1)
      else
        @@current_user = User.find_by(username: username)
        if @@current_user
          system "clear"
          password = @@prompt.mask("Type in your password: ")
          if @@current_user.password == password
            puts "Welcome to Osumazon!"
          else
            puts "Wrong password"
            @@current_user = nil
          end
        else
          system "clear"
          puts "Invalid username."
        end
      end
    end
    @@current_user
  end

  def self.add_to_cart(product)
    @@cart << product
  end

  def self.review_cart
    choices = {}
    @@cart.each_with_index do |item, i|
      choices["#{i+1}. #{item.name}"] = i
    end
    indices_to_delete = @@prompt.multi_select("Press 'SPACE' to choose items to remove. Press 'ENTER' to continue.", choices)
    indices_to_delete.each do |index|
      if @@prompt.select("Are you sure you want to delete #{@@cart[index].name}?", ["Yes", "No"]) == "Yes"
        puts "Deleted #{@@cart[index].name}."
        @@cart.delete_at(index)
      end
    end
  end

  def self.menu
    options = ["Shop", "Checkout", "Prior Purchases", "Settings", "Logout"]
    logged_out = false

    while @@current_user
      choice = @@prompt.select("What would you like to do? ", options)
      case choice
      when "Shop"
        system "clear"
        shop
        system "clear"
      when "Checkout"
        system "clear"
        if @@cart.empty?
          invalid_cart_message
        else
          review_cart
          system "clear"
          if @@cart.empty?
            invalid_cart_message
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
        @@current_user.display_transactions
        system "clear"
      end
    end
  end

  def self.logout
    system "clear"
    puts "You are logged out."
    sleep(1)
    @@current_user = nil
    @@cart = []
  end

  def self.checkout
    sum = 0.0
    @@cart.each do |item|
      sum += item.price
    end
    system "clear"
    puts "Your cart is $#{'%.2f' % sum}."
    if @@prompt.select("Do you wish to checkout?", ["Yes", "No"]) == "Yes"
      @@cart.each do |item|
        new_trans = Transaction.find_or_create_by(user_id: @@current_user.id , electronic_id: item.id)
        new_trans.quantity ||= 0
        new_trans.quantity += 1
        new_trans.save
      end
      @@cart = []
      puts "You spent $#{'%.2f' % (sum * 1.08875)}."
      sleep(1)
      print "Press any key to continue: "
      STDIN.getch
    else
      puts "Okay, bye!"
    end
  end

  def self.shop
    complete = false
    categories = Electronic.categories.uniq
    categories << "exit"

    until complete
      system "clear"
      category = @@prompt.select("Select a category: ", categories)
      if category == "exit"
        complete = true
      else
        product_names = Electronic.where(category: category).map {|p| p.name}
        product_names << "exit"
        product_name = @@prompt.select("Select an item: ", product_names)
        if product_name != "exit"
          product = Electronic.find_by(name: product_name)
          print "$#{'%.2f' % product.price} "
          if @@prompt.select('Add to cart?', ["Yes", "No"]) == "Yes"
            add_to_cart(product)
          end
        end
        category = nil
        product_name = nil
      end
    end
  end

  def self.menu_start(message, options)
    system "clear"
    done = false
    until done
      choice = @@prompt.select(message, options)
      system "clear"
      done = yield choice
    end
  end

  def self.start
    welcome_message = "Welcome to Osumazon! What would you like to do?"
    choices = ["Login", "Create Account", "Quit"]
    self.menu_start(welcome_message, choices) do |choice|
      case choice
      when "Login"
        if self.login
          self.menu
        end
      when "Create Account"
        @@current_user = User.create_account
        system "clear"
        @@current_user
      when "Quit"
        puts "Bye, bye from Osumazon!"
        sleep(2)
        true
      end
    end
  end

  def self.settings
    settings_message = "Settings"
    options = ["Change Password", "Delete Account", "<< Back"]
    self.menu_start(settings_message, options) do |choice|
      case choice
      when "Change Password"
        @@current_user.change_password
        false
      when "Delete Account"
        if @@current_user.delete_account
          self.logout
          true
        end
      when "<< Back"
        true
      end
    end
  end
end
