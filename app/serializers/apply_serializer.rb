# frozen_string_literal: true

class ApplySerializer < ActiveModel::Serializer
  attributes :id, :job_id, :user_id, :feedback_headhunter
end
