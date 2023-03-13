class Assist < ApplicationRecord
  belongs_to :question
  belongs_to :asker, class_name: "User"
  belongs_to :receiver, class_name: "User"
end
