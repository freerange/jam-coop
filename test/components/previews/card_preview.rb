# frozen_string_literal: true

class CardPreview < Lookbook::Preview
  def default
    render('shared/card',
           title: 'Fables of the reconstruction',
           subtitle: 'R.E.M.',
           image_url: 'https://upload.wikimedia.org/wikipedia/en/d/dc/R.E.M._-_Fables_of_the_Reconstruction.jpg')
  end
end
