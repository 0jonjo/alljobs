# frozen_string_literal: true

module ProposalsHelper
  def translate_user_acceptance(user_acceptance)
    I18n.t(user_acceptance)
  end
end
