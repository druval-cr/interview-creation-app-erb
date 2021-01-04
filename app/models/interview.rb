class Interview < ApplicationRecord
    has_and_belongs_to_many :participants

    has_attached_file :resume
    validates_attachment_content_type :resume, content_type: "application/pdf"

    #validates :resume, presence: true

    def self.valid_attributes(interview)
        if interview.title.nil? or interview.start_time.nil? or interview.end_time.nil?
            return false
        end
        return true
    end

    def self.valid_duration(interview)
        return (interview.start_time < interview.end_time)
    end

    def self.time_overlap(interview)
        interview.participants.each do |participant|
			participant.interviews.each do |checkInterview|
				if interview.id == checkInterview.id or interview.start_time > checkInterview.end_time or interview.end_time < checkInterview.start_time
					next
				else
                    return true
				end
			end
        end
        return false
    end
end
