
class HelpController < TagTreeController
  skip_before_action :authenticate_user!

  def index
  end

  def demo
    sign_in demo_user

    redirect_to :tags, notice: "Signed in as a registered user for a demo. Please click link 'End demo' once you're finished, thanks."
  end

  private

  def demo_user
    user = User.find_by email: DEMO_EMAIL

    user.singleton_class.class_eval { def password_required?; false end }

    user
  end
end

