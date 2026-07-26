# frozen_string_literal: true

class NullUser
  def admin?
    false
  end

  def artists
    Artist.none
  end

  def verified?
    false
  end

  def signed_in?
    false
  end
end
