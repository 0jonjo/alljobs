class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_one :proposal
  
  def user_email
    @user = User.find(user_id)
    "#{@user.email}"
  end
end
