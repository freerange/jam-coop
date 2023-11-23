# frozen_string_literal: true

class AlbumMailer < ApplicationMailer
  def request_publication
    @album = params[:album]

    mail to: 'contact@jam.coop', subject: "#{@album.artist.name} has requested publication of #{@album.title}"
  end
end
