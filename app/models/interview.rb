class Interview < ApplicationRecord
    has_and_belongs_to_many :participants

    has_attached_file :resume, styles: { thumbnail: "60x60#" }
    validates_attachment_content_type :resume, content_type: "application/pdf"

    validates :title, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
    #validates :resume, presence: true
end
