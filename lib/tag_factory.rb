
class TagFactory < Struct.new(:tag)
  def call(*children)
    tags tag, *children
  end

  def tags(parent, *children)
    children.flatten.map do |child|
      case child
      when Tag
        child.update tag: parent and child
      when String, Symbol
        parent.tags.create name: child.to_s
      when Hash
        parent.tags.create child
      end
    end
  end

  class << self
    def call(name, user=nil, title: name.titleize, tag: nil)
      #Tag.create user_id: user.to_param, name: name, title: title, tag: tag
      Tag.create name: name, title: title, tag: tag
    end

    def tags(name_or_tag, *names)
      new(Tag === name_or_tag ? name_or_tag : self.(name_or_tag)).(names)
    end
  end
end
