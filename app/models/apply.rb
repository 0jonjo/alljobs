class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :user
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :job
  
  def user_email
    @user = User.find(user_id)
    "#{@user.email}"
  end
end
