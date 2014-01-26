class Job < ActiveRecord::Base
  attr_accessible :due_date, :user_id, :job_status_id
  has_many :posters
  belongs_to :user
  belongs_to :job_status
end