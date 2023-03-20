require 'open-uri'
require 'json'
require 'date'
class NewGameJob < ApplicationJob
  queue_as :default

  def perform
    update_players_lifeline
    url = "https://the-trivia-api.com/api/questions/"
    trivia_serialized = URI.open(url).read
    trivia = JSON.parse(trivia_serialized)
    create_questions(trivia)
  end

  private

  def update_players_lifeline
    users = User.all
    users.each do |user|
      user.lifeline_count = 3
      user.save
    end
  end

  def create_questions(trivia)
    trivia.each do |t|
      question = Question.create(prompt: t['question'], difficulty: t['difficulty'], question_date: Date.today)
      choice = Choice.new
      choice.question_id = question.id
      choice.content = t['correctAnswer']
      choice.correct = true

      choice2 = Choice.new
      choice2.question_id = question.id
      choice2.content = t['incorrectAnswers'].pop
      choice2.correct = false

      choice3 = Choice.new
      choice3.question_id = question.id
      choice3.content = t['incorrectAnswers'].pop
      choice3.correct = false

      choice4 = Choice.new
      choice4.question_id = question.id
      choice4.content = t['incorrectAnswers'].pop
      choice4.correct = false

      choices = [choice, choice2, choice3, choice4].shuffle
      choices.each(&:save)
    end
  end
end
