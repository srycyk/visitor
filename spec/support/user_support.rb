
require 'active_support/concern'

module UserSupport
  extend ActiveSupport::Concern

  included do
    let(:user) { create_user }

    #before { signin(user.email, user.password) }
  end

  def create_user
    user = User.create email: Faker::Internet.email,
                       confirmed_at: Time.now,
                       name: Faker::Name.name,
                       password: "password"

    user.confirm if user.respond_to? :confirm

    user
  end
end
