class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :electronic

  def self.display_transactions(user)
    user.transactions.each do |transaction|
      puts "You bought #{transaction.quantity} #{transaction.electronic.name}(s) --> #{'%.2f' % ((transaction.electronic.price * transaction.quantity) * 1.08875)}"
    end
  end
end
