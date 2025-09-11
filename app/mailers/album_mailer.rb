# frozen_string_literal: true

class AlbumMailer < ApplicationMailer
  def published
    @album = params[:album]

    return unless (user = @album.artist.user)
    return if user.suppress_sending?

    mail to: user.email, subject: "Your album #{@album.title} has been published"
  end
end
