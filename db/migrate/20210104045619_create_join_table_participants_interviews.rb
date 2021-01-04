class CreateJoinTableParticipantsInterviews < ActiveRecord::Migration[5.1]
  def change
    create_join_table :participants, :interviews do |t|
      # t.index [:participant_id, :interview_id]
      # t.index [:interview_id, :participant_id]
    end
  end
end
