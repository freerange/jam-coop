# frozen_string_literal: true

require 'test_helper'

class AlbumHelperTest < ActionView::TestCase
  test 'format_metadata wraps text in p tags with a bottom margin ' do
    assert_dom_equal '<p class="mb-2">foo</p>', format_metadata('foo')
  end

  test 'format_metadata sanitizes' do
    assert_dom_equal '<p class="mb-2">foo</p>', format_metadata('<script>foo</script>')
  end

  test 'format_metadata underlines links and strips the protocol' do
    assert_includes format_metadata('http://example.com'), '<a class="underline" href="http://example.com">example.com</a>'
    assert_includes format_metadata('https://example.com'), '<a class="underline" href="https://example.com">example.com</a>'
  end
end
