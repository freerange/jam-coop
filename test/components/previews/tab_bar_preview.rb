# frozen_string_literal: true

class TabBarPreview < Lookbook::Preview
  def default
    render('shared/tab_bar', items: [
             { title: 'First', selected: true },
             { title: 'Second', link: 'https://example.com' },
             { title: 'Third', link: 'https://example.com', icon: true }
           ])
  end
end
