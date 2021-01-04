class AddAttachmentResumeToInterviews < ActiveRecord::Migration[5.1]
  def self.up
    change_table :interviews do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :interviews, :resume
  end
end
