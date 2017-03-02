
FactoryGirl.define do
  factory :bookmark do
    url { Faker::Internet.url }
    title { Faker::Ancient.titan + ' ' + Faker::Ancient.titan }
    description { Faker::Ancient.hero + ' ' + Faker::Ancient.hero }
    tag nil
  end
end
