# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :routing do
  it { should route(:get, '/api/v1/profiles').to('api/v1/profiles#index', format: :json) }
  it { should route(:get, '/api/v1/profiles/1').to('api/v1/profiles#show', id: '1', format: :json) }
  it { should route(:post, '/api/v1/profiles').to('api/v1/profiles#create', format: :json) }
  it { should route(:put, '/api/v1/profiles/1').to('api/v1/profiles#update', id: '1', format: :json) }
  it { should route(:patch, '/api/v1/profiles/1').to('api/v1/profiles#update', id: '1', format: :json) }
  it { should_not route(:delete, '/api/v1/profiles/1').to('api/v1/profiles#destroy', id: '1', format: :json) }
end
