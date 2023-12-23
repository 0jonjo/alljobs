# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AppliesController, type: :routing do
  it { should route(:get, '/api/v1/jobs/1/applies').to('api/v1/applies#index', job_id: 1, format: :json) }
  it { should route(:get, '/api/v1/jobs/1/applies/1').to('api/v1/applies#show', id: '1', job_id: 1, format: :json) }
  it { should route(:post, '/api/v1/jobs/1/applies').to('api/v1/applies#create', job_id: 1, format: :json) }
  it {
    should_not route(:put, '/api/v1/jobs/1/applies/1').to('api/v1/applies#update', id: '1', job_id: 1, format: :json)
  }
  it {
    should_not route(:patch, '/api/jobs/1/v1/applies/1').to('api/v1/applies#update', id: '1', job_id: 1, format: :json)
  }
  it {
    should route(:delete, '/api/v1/jobs/1/applies/1').to('api/v1/applies#destroy', id: '1', job_id: 1, format: :json)
  }
end
