# frozen_string_literal: true

class FormPreview < Lookbook::Preview
  def default
    artist = Artist.create(location: 'London')
    render template: 'templates/example_form', locals: { artist: }
  end
end
