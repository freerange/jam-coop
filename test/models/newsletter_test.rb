# frozen_string_literal: true

require 'test_helper'

class NewsletterTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:newsletter).valid?
  end
end
