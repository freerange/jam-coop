# frozen_string_literal: true

class AlbumMailer < ApplicationMailer
  def request_publication
    @album = params[:album]

    mail to: 'contact@jam.coop', subject: "#{@album.artist.name} has requested publication of #{@album.title}"
  end

  def published
    @album = params[:album]

    return unless (user = @album.artist.user)
    return if user.suppress_sending?

    mail to: user.email, subject: "Your album #{@album.title} has been published"
  end
end
