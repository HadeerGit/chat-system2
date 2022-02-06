class Application < ApplicationRecord
  # model association
  has_many :chats, :dependent => :delete_all

  # validations
  validates_presence_of :name

  before_create :set_token
  private
  def set_token
    self.token = generate_token
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.hex(10)
      break random_token unless Application.exists?(token: random_token)
    end
  end
end
