require "json"
require "open-uri"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
p "Cleaning database"
User.destroy_all
UserChoice.destroy_all
Choice.destroy_all
Friendship.destroy_all
Question.destroy_all
Assist.destroy_all

p "Creating users"

user1 = User.create(
  username: "Donald",
  email: "test@test.com",
  password: 'test123',
  lifeline_count: 3
)

user2 = User.create(
  username: "Mickey",
  email: "test2@test.com",
  password: 'test123',
  lifeline_count: 3
)

user3 = User.create(
  username: "Skoot",
  email: "test3@test.com",
  password: 'test123',
  lifeline_count: 3
)

user4 = User.create(
  username: "Mandela",
  email: "test4@test.com",
  password: 'test123',
  lifeline_count: 3
)

user5 = User.create(
  username: "Adem sandler",
  email: "test5@test.com",
  password: 'test123',
  lifeline_count: 3
)

user6 = User.create(
  username: "Broom",
  email: "test6@test.com",
  password: 'test123',
  lifeline_count: 3
)

user7 = User.create(
  username: "Jackey",
  email: "test7@test.com",
  password: 'test123',
  lifeline_count: 3
)

user8 = User.create(
  username: "Saj",
  email: "test8@test.com",
  password: 'test123',
  lifeline_count: 3
)

user9 = User.create(
  username: "Kamool",
  email: "test9@test.com",
  password: 'test123',
  lifeline_count: 3
)

user10 = User.create(
  username: "Jesus",
  email: "test10@test.com",
  password: 'test123',
  lifeline_count: 3
)
p "Accessing api"
url = "https://the-trivia-api.com/api/questions/"
trivia_serialized = URI.open(url).read
trivia = JSON.parse(trivia_serialized)
p "creating questions"

trivia.each do |t|
  question = Question.new
  question.prompt = t['question']
  question.difficulty = t['difficulty']
  question.save
  p "created question with id#{question.id}"
  choice = Choice.new
  choice.question_id = question.id
  choice.content = t['correctAnswer']
  choice.correct = true
  choice.save
  choice2 = Choice.new
  choice2.question_id = question.id
  choice2.content = t['incorrectAnswers'].pop
  choice2.correct = false
  choice2.save
  choice3 = Choice.new
  choice3.question_id = question.id
  choice3.content = t['incorrectAnswers'].pop
  choice3.correct = false
  choice3.save
  choice4 = Choice.new
  choice4.question_id = question.id
  choice4.content = t['incorrectAnswers'].pop
  choice4.correct = false
  choice4.save
  choices = [choice, choice2, choice3, choice4]
  userchoice = UserChoice.create(
    user_id: user2.id,
    choice_id: choices.sample.id
  )
  p userchoice
end

p "created #{Question.count} questions"
friendship1 = Friendship.new
friendship1.asker = user1
friendship1.receiver = user2
friendship1.save

friendship3 = Friendship.new
friendship3.asker = user3
friendship3.receiver = user2
friendship3.save

friendship3 = Friendship.new
friendship3.asker = user4
friendship3.receiver = user6
friendship3.save

friendship4 = Friendship.new
friendship4.asker = user3
friendship4.receiver = user5
friendship4.save

friendship5 = Friendship.new
friendship5.asker = user1
friendship5.receiver = user7
friendship5.save

friendship6 = Friendship.new
friendship6.asker = user9
friendship6.receiver = user4
friendship6.save

friendship7 = Friendship.new
friendship7.asker = user5
friendship7.receiver = user4
friendship7.save

friendship8 = Friendship.new
friendship8.asker = user7
friendship8.receiver = user9
friendship8.save

friendship9 = Friendship.new
friendship9.asker = user8
friendship9.receiver = user9
friendship9.save

friendship10 = Friendship.new
friendship10.asker = user10
friendship10.receiver = user2
friendship10.save
