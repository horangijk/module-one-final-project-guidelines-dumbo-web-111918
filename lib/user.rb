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
        else
          puts "Invalid username."
        end
      end
    end
  end
end
