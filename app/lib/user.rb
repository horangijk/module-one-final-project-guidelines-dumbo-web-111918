class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions

  @@prompt = TTY::Prompt.new

  def display_transactions
    self.reload()
    if self.transactions.empty?
      puts "No prior purchases."
      sleep(1)
    else
      self.transactions.each do |transaction|
        puts "You bought #{transaction.quantity} #{transaction.electronic.name}(s) --> #{'%.2f' % ((transaction.electronic.price * transaction.quantity) * 1.08875)}"
      end
      print "Press any key to continue: "
      STDIN.getch
    end
  end

  def self.create_account
    new_user = nil
    done = false
    until new_user || done
      username = @@prompt.ask("Enter your new username (can’t be 'exit'): ")
      system "clear"
      if username == "exit"
        puts "Well, we told you, it can’t be 'exit'"
        if @@prompt.select("Would you like to exit?", ["Yes", "No"]) == "Yes"
          done = true
        end
      elsif !self.find_by(username: username)
        password = @@prompt.mask("Enter your new password: ")
        new_user = User.create(username: username, password: password)
        puts "Your new account details. Username: #{username}, Password: #{password}."
      else
        puts "Username already chosen!"
      end
    end
    new_user
  end

  def delete_account()
    done = false
    until !self || done
      if @@prompt.select('Are you sure you want to delete your account?', ["Yes", "No"]) == "Yes"
        password = @@prompt.mask("Type in your password: ")
        system "clear"
        if password == self.password
          self.destroy
          exit = true
          puts "Sorry to see you go! :("
          sleep(2)
        else
          puts "Wrong password."
          sleep(2)
        end
      else
        done = true
      end
    end
    !self
  end

  def change_password
    if @@prompt.select('Are you sure you want to update your password?', ["Yes", "No"]) == "Yes"
      if self.password == @@prompt.ask("Enter old password: ")
        password = @@prompt.mask("Type in your new password: ")
        system "clear"
        if password == self.password
          puts "Cannot change password. Cannot use the same password."
          sleep(2)
        else
          self.password = password
          self.save
          puts "Password updated."
          sleep(2)
        end
      else
        "You don’t have permission!"
        sleep(2)
      end
    end
  end
end
