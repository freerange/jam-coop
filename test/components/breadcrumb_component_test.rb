# frozen_string_literal: true

require 'test_helper'

class BreadcrumbComponentTest < ViewComponent::TestCase
  test 'renders breadcrumb text' do
    items = [
      { text: 'Account' }
    ]

    render_inline(BreadcrumbComponent.new(items: items))

    assert_selector 'li', text: 'Account'
  end

  test 'renders breadcrumb link' do
    items = [
      { text: 'Account', link: '/account' }
    ]

    render_inline(BreadcrumbComponent.new(items: items))

    assert_selector "li a[href='/account']", text: 'Account'
  end

  test 'adds underline to breadcrumb links' do
    items = [
      { text: 'Account', link: '/account' }
    ]

    render_inline(BreadcrumbComponent.new(items: items))

    assert_selector 'a.hover\:underline', text: 'Account'
  end

  test 'renders separators between items' do
    items = [
      { text: 'Account', link: '/account' },
      { text: 'Artist' }
    ]

    render_inline(BreadcrumbComponent.new(items: items))

    assert_selector 'li.text-slate-400', text: '/', count: 1
  end
end
