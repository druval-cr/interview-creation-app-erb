class InterviewUpdateJob < ApplicationJob
  queue_as :default

  def perform(interview_id)
    # Do something later
    interview = Interview.find(interview_id)
    interview.participants.each do |participant|
      InterviewUpdateMailer.interview_update_email(participant).deliver
    end
  end
end
