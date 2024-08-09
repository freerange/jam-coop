# frozen_string_literal: true

class CardComponentPreview < ViewComponent::Preview
  def default
    render(
      CardComponent.new(
        title: 'Fables of the Reconstuction',
        subtitle: 'R.E.M.',
        image: 'https://upload.wikimedia.org/wikipedia/en/d/dc/R.E.M._-_Fables_of_the_Reconstruction.jpg'
      )
    )
  end
end
