User.destroy_all
Transaction.destroy_all
Electronic.destroy_all
switch = Electronic.create(
  name: "Nintendo Switch",
  category: "Video Game Console",
  price: 299.99
)
xbox1 = Electronic.create(
  name: "Microsoft Xbox One X",
  category: "Video Game Console",
  price: 399.99
)
playstation4 = Electronic.create(
  name: "Sony Playstation 4",
  category: "Video Game Console",
  price: 399.99
)
nintendo_2DS = Electronic.create(
  name: "Nintendo 2DS",
  category: "Video Game Console",
  price: 79.99
)
razor = Electronic.create(
  name: "Philips Electric Razor",
  category: "Hygiene",
  price: 50.05
)
nose_hair_trimmer = Electronic.create(
  name: "Philips Electric Nose Hair Trimmer",
  category: "Hygiene",
  price: 19.99
)
samsung = Electronic.create(
  name: "Samsung OLED Television",
  category: "TV",
  price: 1050.00
)
lg = Electronic.create(
  name: "LG  - 43 inch LED 4K UHD TV with HDR",
  category: "TV",
  price: 249.99
)
sony = Electronic.create(
  name: "SONY OLED Television",
  category: "TV",
  price: 3500.00
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
