class InterviewUpdateMailer < ApplicationMailer
    default from: 'interviewschedulererb@example.com'
  
    def interview_update_email(participant)
      mail(to: participant.email, subject: 'Interview Update')
    end
end
