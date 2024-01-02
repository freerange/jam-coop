# frozen_string_literal: true

require 'test_helper'

class PurchaseExporterTest < ActiveSupport::TestCase
  setup do
    @today = Date.new(2024, 1, 1)
  end

  test 'export only includes purchases from last month' do
    included_purchase = create(:purchase, created_at: Date.new(2023, 12, 1))
    excluded_purchase = create(:purchase, created_at: Date.new(2023, 11, 30))
    export = PurchaseExporter.new(@today).to_csv

    assert_includes export, included_purchase.id
    assert_not_includes export, excluded_purchase.id
  end

  test 'export only includes completed purchases' do
    included_purchase = create(:purchase, completed: true, created_at: Date.new(2023, 12, 1))
    excluded_purchase = create(:purchase, completed: false, created_at: Date.new(2023, 12, 1))
    export = PurchaseExporter.new(@today).to_csv

    assert_includes export, included_purchase.id
    assert_not_includes export, excluded_purchase.id
  end

  test 'export includes purchase details' do
    create(:purchase, price: 7.00, amount_tax: 123, created_at: Date.new(2023, 12, 1))

    export = PurchaseExporter.new(@today).to_csv

    assert_includes export, '700'
    assert_includes export, '123'
  end

  test 'export includes artists email' do
    purchase = create(:purchase, created_at: Date.new(2023, 12, 1))

    export = PurchaseExporter.new(@today).to_csv

    assert_includes export, purchase.album.artist.user.email
  end

  test 'export includes artists payout details' do
    purchase = create(:purchase, created_at: Date.new(2023, 12, 1))
    payout_detail = create(:payout_detail, user: purchase.album.artist.user)

    export = PurchaseExporter.new(@today).to_csv

    assert_includes export, payout_detail.name
    assert_includes export, payout_detail.country
  end

  test 'export includes artist/album details' do
    purchase = create(:purchase, created_at: Date.new(2023, 12, 1))

    export = PurchaseExporter.new(@today).to_csv

    assert_includes export, purchase.album.title
    assert_includes export, purchase.album.artist.name
  end
end
