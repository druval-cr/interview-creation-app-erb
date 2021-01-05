class InterviewUpdateJob < ApplicationJob
  queue_as :default

  def perform(participant)
    # Do something later
    InterviewUpdateMailer.interview_update_email(participant).deliver
  end
end
