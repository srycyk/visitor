
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tags, dependent: :destroy

  has_many :bookmarks, through: :tags

  before_create :derive_name

  def to_s
    name.presence or email
  end

  private

  def derive_name
    if name.blank?
      self.name = email[0, email.index('@')].humanize
    end
  end
end
