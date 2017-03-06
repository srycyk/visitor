
class HelpController < TagTreeController
  skip_before_action :authenticate_user!

  def index
  end

  private

end

