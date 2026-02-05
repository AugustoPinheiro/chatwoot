FactoryBot.define do
  factory :conversation_group_member do
    conversation
    contact { association :contact, account: conversation.account }

    trait :admin do
      role { :admin }
    end

    trait :inactive do
      is_active { false }
    end
  end
end
