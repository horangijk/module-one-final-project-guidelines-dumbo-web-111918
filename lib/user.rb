class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions

  def self.login
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
        else
          puts "Invalid username."
        end
      end
    end
  end

  def self.create_account
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

  def shop
    categories = Electronic.categories
    prompt = TTY::Prompt.new
    category = prompt.enum_select("Select from the following: ", categories)
    Electronic.where(category: category)

  end
end
