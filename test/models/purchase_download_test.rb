# frozen_string_literal: true

require 'test_helper'

class PurchaseDownloadTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:purchase_download).valid?
  end
end
