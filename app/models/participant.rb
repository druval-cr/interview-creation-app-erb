class Participant < ApplicationRecord
    has_and_belongs_to_many :interviews, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
end
