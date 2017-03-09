
=begin
  ActiveRecord::Base.transaction do
    user = CreateAdminService.new.call

    Tag.delete_all

    Tag.create_tree user, :misc, :radio
    Tag.create_tree user, :lang, :ruby
    Tag.create_tree user, :lang, :js
    Tag.create_tree user, :lang, :html
  end
=end

