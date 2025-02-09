require 'pg_search'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships_as_asker, class_name: "Friendship", foreign_key: :asker_id, dependent: :destroy
  has_many :friendships_as_receiver, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy

  has_many :assists_as_asker, class_name: "Assist", foreign_key: :asker_id, dependent: :destroy
  has_many :assists_as_receiver, class_name: "Assist", foreign_key: :receiver_id, dependent: :destroy

  has_many :user_choices, dependent: :destroy

  has_many :choices, through: :user_choices

  has_many :users

  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_by_username, against: [:username]
  # , using: { search: { prefix: true } }
  validates :username, presence: true, uniqueness: true, length: { maximum: 12,
                                                                   too_long: "12 characters is the maximum allowed" }

  def next_question
    questions = []
    unanswered_questions.each do |question|
      if assists_as_asker.find_by(question_id: question.id).nil?
        questions.push(question)
      else
        questions.unshift(question)
      end
    end
    questions.pop
  end

  def unanswered_questions
    Question.where.not(id: choices.map(&:question_id)).where(question_date: Date.today)
  end

  def score
    choices.count(&:correct)
  end

  def answered
    choices.count
  end

  def score_today
    score_today = []
    choices.each do |choice|
      score_today.push(choice) if choice.question.question_date == Date.today
    end
    score_today.count(&:correct)
  end

  def answered_today_block
    # get 10 qs for the day
    questions = Question.today
    questions.map do |question|
      question_choice = choices.find { |choice| choice.question == question }
      # if user has choice for the q
      next nil unless question_choice

      question_choice.correct
      # if choice is correct - true
      # if incorrect - false
      # if user doesnt have choice for q - nil
    end
  end

  def answered_today
    choices.count { |c| c.question.question_date == Date.today }
  end

  def all_friends
    friendships_as_asker.map(&:receiver) + friendships_as_receiver.map(&:asker)
  end

  def all_confirmed_friends
    users = []
    friendships_as_asker.where(status: :accept).each do |friendship|
      users << friendship.receiver
    end

    friendships_as_receiver.where(status: :accept).each do |friendship|
      users << friendship.asker
    end
    users
  end

  def all_pending_friends
    users = []
    friendships_as_asker.each do |friendship|
      users << User.find(friendship.receiver_id)
    end

    friendships_as_receiver.each do |friendship|
      users << User.find(friendship.asker_id)
    end
    users
  end

  def have_answered?(question)
    choices.where(question: question).any?
  end
end
