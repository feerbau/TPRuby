# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user = User.create email:"test@test.com", username: "test" , password: "1234", password_confirmation: "1234"

(1..10).each do |i|
	book = Book.create title: "Book #{i}", user: user

	1.upto(rand(1..20)) do |j|
		book.notes.create title: "Nota #{j} from book #{book}", content: "Content for note #{j}", user: user
	end

end