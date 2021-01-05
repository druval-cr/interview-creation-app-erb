class InterviewReminderJob < ApplicationJob
  queue_as :default

  def perform(participant)
    # Do something later
    InterviewReminderMailer.interview_reminder_email(participant).deliver
  end
end
