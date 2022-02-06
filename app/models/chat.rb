class Chat < ApplicationRecord
  # model association
  belongs_to :application
  has_many :messages, :dependent => :delete_all

end
