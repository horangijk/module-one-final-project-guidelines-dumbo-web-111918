User.destroy_all
Transaction.destroy_all
Electronic.destroy_all

razor = Electronic.create(
  name: "Electric Razor",
  category: "Hygiene",
  price: 50.05
)
samsung = Electronic.create(
  name: "Samsung OLED Television",
  category: "TV",
  price: 450.00
)
iphone5 = Electronic.create(
  name: "iPhone 5",
  category: "Cellphones",
  price: 120.00
)
iphone6 = Electronic.create(
  name: "iPhone 6",
  category: "Cellphones",
  price: 160.00
)
iphone7 = Electronic.create(
  name: "iPhone 7",
  category: "Cellphones",
  price: 290.00
)
iphone8 = Electronic.create(
  name: "iPhone 8",
  category: "Cellphones",
  price: 590.00
)
iphoneXSMax = Electronic.create(
  name: "iPhone XS Max",
  category: "Cellphones",
  price: 1099.00
)
iphoneXS = Electronic.create(
  name: "iPhone XS",
  category: "Cellphones",
  price: 999.00
)
iphoneXR = Electronic.create(
  name: "iPhone XR",
  category: "Cellphones",
  price: 740.00
)
jerold = User.create(username: "horangijk", password: "jerry89")
john_mark = User.create(username: "johomurk", password: "mohawk123")
# transaction1 = Transaction.create(user: jerold, electronic: razor)
puts "done with seeds"
