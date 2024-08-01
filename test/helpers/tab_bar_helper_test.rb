# frozen_string_literal: true

require 'test_helper'

class TabBarHelperTest < ActionView::TestCase
  test 'tab_bar_item adds selected class if item is selected' do
    assert_dom_equal '<li class="jam-tab-bar__selected"></li>', tab_bar_item({ selected: true })
  end

  test 'tab_bar_item does not add selected class if item is not selected' do
    assert_dom_equal '<li></li>', tab_bar_item({})
  end

  test 'tab_bar_item uses provided title' do
    assert_dom_equal '<li>foo</li>', tab_bar_item({ title: 'foo' })
  end

  test 'tab_bar_item links to provided title if link provided' do
    assert_dom_equal(
      '<li><a href="https://example.com">foo</a></li>',
      tab_bar_item({ title: 'foo', link: 'https://example.com' })
    )
  end

  test 'tab_bar_item can include icon' do
    expected = %(
    <li>
      <span class="icon">
        <svg width="0.75em" height="0.75em" viewBox="0 0 14 15" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M14 8.5H8V14.5H6V8.5H0V6.5H6V0.5H8V6.5H14V8.5Z" fill="#F16B7C"/>
        </svg>
      </span>
      <a href="https://example.com">foo</a>
    </li>
    )

    assert_dom_equal(
      expected,
      tab_bar_item({ title: 'foo', link: 'https://example.com', icon: true })
    )
  end
end
