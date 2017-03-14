
  ActiveRecord::Base.transaction do
    user = CreateAdminService.new.call

    Tag.roots.delete_all

    #Tag.create_tree user, :misc
  end

