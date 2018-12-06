class User < ActiveRecord::Base
  has_many :transactions
  has_many :electronics, through: :transactions

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

  def delete_account
    prompt = TTY::Prompt.new
    deleted = false
    return_val = false
    until deleted
      if prompt.select('Are you sure you want to delete your account?', ["Yes", "No"]) == "Yes"
        delete_account_password = prompt.mask("Type in your password: ")
        if delete_account_password == $current_user.password
          self.destroy
          exit = true
          system "clear"
          puts "Sorry to see you go! :("
          sleep(1)
          deleted = true
          return_val = true
        else
          system "clear"
          puts "Wrong password."
          sleep(1)
          deleted = false
        end
      else
        deleted = true
      end
    end
    return_val
  end

  def change_password
    prompt = TTY::Prompt.new
    if prompt.select('Are you sure you want to update your password?', ["Yes", "No"]) == "Yes"
      password = prompt.mask("Type in your new password: ")
      if password == self.password
        system "clear"
        puts "Cannot change password. Cannot use the same password."
        sleep(2)
      else
        self.password = password
        self.save
        system "clear"
        puts "Password updated."
        sleep(2)
      end
    end
  end
end
