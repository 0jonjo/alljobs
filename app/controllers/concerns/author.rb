# frozen_string_literal: true

module Author
  def author
    if headhunter_signed_in?
      @author_id = current_headhunter.id
      @author_type = current_headhunter.class.to_s
    else
      @author_id = current_user.id
      @author_type = current_user.class.to_s
    end
  end
end
