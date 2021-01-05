class InterviewReminderMailer < ApplicationMailer
    default from: 'interviewschedulererb@example.com'
  
    def interview_reminder_email(participant)
      mail(to: participant.email, subject: 'Interview Reminder')
    end
end
