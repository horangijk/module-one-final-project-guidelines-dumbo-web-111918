User.destroy_all
Transaction.destroy_all
Electronic.destroy_all

razor = Electronic.create(
  name: "Electric Razor",
  category: "Hygiene",
  price: 50.05)
samsung = Electronic.create(
  name: "Samsung OLED Television",
  category: "Televisions",
  price: 450.00)
jerold = User.create(username: "horangijk", password: "jerry89")
john_mark = User.create(username: "johomurk", password: "mohawk123")
# transaction1 = Transaction.create(user: jerold, electronic: razor)
puts "done with seeds"
