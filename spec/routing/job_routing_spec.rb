# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :routing do
  it { should route(:get, '/api/v1/jobs').to('api/v1/jobs#index', format: :json) }
  it { should route(:get, '/api/v1/jobs/1').to('api/v1/jobs#show', id: '1', format: :json) }
  it { should route(:post, '/api/v1/jobs').to('api/v1/jobs#create', format: :json) }
  it { should route(:put, '/api/v1/jobs/1').to('api/v1/jobs#update', id: '1', format: :json) }
  it { should route(:patch, '/api/v1/jobs/1').to('api/v1/jobs#update', id: '1', format: :json) }
  it { should route(:delete, '/api/v1/jobs/1').to('api/v1/jobs#destroy', id: '1', format: :json) }
end
