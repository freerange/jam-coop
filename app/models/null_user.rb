# frozen_string_literal: true

class NullUser
  def admin?
    false
  end

  def artists
    []
  end

  def verified?
    false
  end

  def signed_in?
    false
  end
end
