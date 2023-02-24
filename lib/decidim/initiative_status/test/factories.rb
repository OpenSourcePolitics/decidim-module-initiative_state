# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/initiatives/test/factories"
require "decidim/meetings/test/factories"

FactoryBot.define do
  sequence(:status_name) do |n|
    "#{Faker::Lorem.sentence(word_count: 3)} #{n}"
  end

  factory :status, class: "Decidim::Status" do
    name { Decidim::Faker::Localized.literal(generate(:status_name)) }
    organization
  end
end
