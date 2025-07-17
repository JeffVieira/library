# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

User.create(email: "admin@mail.com", password: "Adminpass123", password_confirmation: "Adminpass123", role: "admin")

member = User.create(email: "member@mail.com", password: "Memberpass123", password_confirmation: "Memberpass123", role: "member")
other_user = User.create(email: "other@mail.com", password: "Otherpass123", password_confirmation: "Otherpass123", role: "member")

# Create some books
50.times do |i|
  Book.create(
    title: Faker::Book.title + " #{i + 1}",
    author: Faker::Book.author,
    genre: ["Fiction", "Non-Fiction", "Science", "History", "Romance"].sample,
    isbn: Faker::Code.isbn + i.to_s,
    copies_available: rand(1..5)
  )
end

# Create some borrows
Book.all.sample(rand(1..20)).each do |book|
  Borrow.create(
    user: [member, other_user].sample,
    book: book,
    due_date: Date.current + rand(1..30),
    returned: [true, false].sample
  )
end

# Create some overdue borrows
Book.all.sample(rand(1..10)).each do |book|
  Borrow.create(
    user: [member, other_user].sample,
    book: book,
    due_date: Date.current - rand(1..10),
    returned: false
  )
end

# Create some due today borrows
Book.all.sample(rand(1..5)).each do |book|
  Borrow.create(
    user: [member, other_user].sample,
    book: book,
    due_date: Date.current,
    returned: false
  )
end