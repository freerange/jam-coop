# frozen_string_literal: true

require 'test_helper'

class TranscodeJobTest < ActiveJob::TestCase
  test 'it transcodes the file' do
    track = create(:track)

    TranscodeJob.perform_now(track)

    assert track.transcodes.last.file.present?
  end
end
