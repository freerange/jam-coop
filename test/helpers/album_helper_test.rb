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

  test 'seconds_to_formated_track_time' do
    assert_equal '03:05', seconds_to_formated_track_time(185)
    assert_equal '', seconds_to_formated_track_time(nil)
  end
end
