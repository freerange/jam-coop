# frozen_string_literal: true

require 'test_helper'

class ReadMetadataCommandTest < ActiveSupport::TestCase
  setup do
    @blob = ActiveStorage::Blob.create_and_upload!(
      io: file_fixture('track-with-title.flac').open,
      filename: 'track-with-title.flac',
      content_type: 'audio/flac'
    )
  end

  test 'extracts title from metadata' do
    metadata = ReadMetadataCommand.new(@blob).execute
    assert_equal 'track-title', metadata[:title]
  end
end
