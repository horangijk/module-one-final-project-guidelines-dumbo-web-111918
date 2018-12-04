class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions

  def self.login
    logged_in = false
    until logged_in
      puts "Enter your username: "
        username = STDIN.gets.chomp
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
