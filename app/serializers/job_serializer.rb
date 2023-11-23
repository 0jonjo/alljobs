class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :skills, :salary, :company_id, :level, :country_id, :city, :date, :job_status
end
