# frozen_string_literal: true

module ProfilesHelper
  def name_to_exibit(profile)
    profile.social_name.blank? ? profile.name : profile.social_name
  end
end
