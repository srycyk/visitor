
require 'tag_factory'

module TagNameFactory
  def create_tag(name, **atts)
    TagFactory.(name, **atts)
  end

  def tag_tree(name_or_tag, *names)
    TagFactory.tags(name_or_tag, names)
  end

  # For testing
  TAG_SPRINT = "level %s"

  def nested_tag(depth)
    return if depth.zero?

    create_tag(TAG_SPRINT % depth, tag: nested_tag(depth - 1))
  end

  # For seeding

  def seed_tag_tree
  end

=begin
  def xseed_tag_tree
    create_tag('git')

    tag_tree('html', 'bootstrap', 'css')

    tag_tree('misc', 'bias', 'psychology', 'radio')

    tag_tree('js', 'lang', 'react', 'vue')

    tag_tree('ruby', 'lang', 'rails')

    create_tag('work')
  end

  def map(max=5, min=1)
    (1..rand(min..max)).map { yield }
  end

  def beer_names
    map(6, 2) { Faker::Beer.name }
  end
  def beer
    tag_tree(Faker::Beer.style, *beer_names)
  end

  def band_names
    map(9, 3) { Faker::RockBand.name }
  end
  def bands
    tag_tree('rock bands', *band_names)
  end

  def race_types
    map { Faker::Demographic.demonym }
  end
  def race_names
    map(3) { Faker::Demographic.race }
  end
  def races
    tag_tree('races', race_types).each do |race|
      tag_tree(race, *race_names)
    end
  end

=end
end
