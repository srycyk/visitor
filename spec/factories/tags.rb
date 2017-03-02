
FactoryGirl.define do
  factory :tag do
    name { Faker::Ancient.primordial + ' ' + Faker::Ancient.primordial }
    title { Faker::Ancient.god + ' ' + Faker::Ancient.god }
    tag nil
  end
end
