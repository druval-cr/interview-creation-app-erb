class InterviewsController < ApplicationController
    def index
        @interviews = Interview.all.order("updated_at desc")
		@map_interview_participants = Hash.new
		@interviews.each do |interview|
			value = ''
			interview.participants.each do |participant|
				value += participant.email + ', '
            end
			@map_interview_participants[interview.id] = value[0...-2]
		end
    end

    def new
        @interview = Interview.new
        @default_participant_id_array = Array.new # No default
    end

	def create
        @interview = Interview.new(interview_params)
        participant_id_array = Array.new
        if not params[:participants]
            @interview.errors[:base] << "Participants must be selected."
			render 'new'
			return
        end
        participant_id_array = params[:participants].map { |e| e.to_i  }
		participant_id_array.each do |participant_id|
			@interview.participants << Participant.find(participant_id)
        end
		valid_attributes = Interview.valid_attributes(@interview)
		if not valid_attributes
			@interview.errors[:base] << "Invalid inputs detected."
			render 'new'
			return
		end
		valid_duration = Interview.valid_duration(@interview)
		if not valid_duration
			@interview.errors[:base] << "Start time should be less than End time"
			render 'new'
			return
		end
		time_overlap = Interview.time_overlap(@interview)
		if time_overlap
			@interview.errors[:base] << "Time overlap occured"
			render 'new'
			return
		end
		@interview.save
		@interview.participants.each do |participant|
			#mail = ParticipantMailer.interview_reminder_email(participant)
			t = Time.now
			current = DateTime.new(t.year,t.month,t.day,t.hour,t.min,t.sec).to_i
			puts (@interview.start_time.utc.to_i - current - 1800)
			InterviewReminderJob.set(:wait => (@interview.start_time.utc.to_i - current - 1800)).perform_later(participant)
		end
		redirect_to interviews_path
	end
	
	def edit
		@interview = Interview.find(params[:id])
		@default_participant_id_array = Array.new
		@interview.participants.each do |participant|
			@default_participant_id_array << participant.id
		end
	end

	def update
		@interview = Interview.find(params[:id])
		currInterview = Interview.new(interview_params)
		currInterview.id = params[:id]
        if not params[:participants]
            @interview.errors[:base] << "Participants must be selected."
			render 'new'
			return
        end
		participant_id_array = params[:participants].map { |e| e.to_i  }
		participant_id_array.each do |participant_id|
			currInterview.participants << Participant.find(participant_id)
		end
		valid_attributes = Interview.valid_attributes(currInterview)
		if not valid_attributes
			@interview.errors[:base] << "Invalid inputs detected."
			render 'edit'
			return
		end
		valid_duration = Interview.valid_duration(currInterview)
		if not valid_duration
			@interview.errors[:base] << "Start time should be less than End time"
			render 'edit'
			return
		end
		time_overlap = Interview.time_overlap(currInterview)
		if time_overlap
			@interview.errors[:base] << "Time overlap occured"
			render 'edit'
			return
		end
		@interview.update(title: currInterview.title, start_time: currInterview.start_time,
			end_time: currInterview.end_time, participants: currInterview.participants, resume: currInterview.resume)
		@interview.participants.each do |participant|
			InterviewUpdateJob.perform_later(participant)
		end
		redirect_to interviews_path
	end

	def destroy
		interview = Interview.find(params[:id])
		interview.destroy
		redirect_to interviews_path
	end

    private
	def interview_params
		params.require(:interview).permit(:title, :start_time, :end_time, :resume)
	end
end
