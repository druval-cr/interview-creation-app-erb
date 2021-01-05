class InterviewReminderJob < ApplicationJob
  queue_as :default

  def perform(interview_id)
    # Do something later
    puts '++++++++++++++++++++++++++++++'
    puts interview_id
    interview = Interview.find(interview_id)
    if not interview.nil?
      t = Time.now
      current = DateTime.new(t.year,t.month,t.day,t.hour,t.min,t.sec).to_i
      interview_start_time = interview.start_time.utc.to_i
      time_diff = interview_start_time - current
      puts time_diff
      if time_diff >= 1740 and time_diff <= 1860
        interview.participants.each do |participant|
          InterviewReminderMailer.interview_reminder_email(participant).deliver
        end
      end
    end
  end
end
