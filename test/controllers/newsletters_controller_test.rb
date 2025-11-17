# frozen_string_literal: true

require 'test_helper'

class NewslettersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get newsletters_path
    assert_response :success
  end

  test 'displays newsletters in reverse published_at order' do
    create(:newsletter, title: 'Newer Newsletter', published_at: 1.day.ago)
    create(:newsletter, title: 'Older Newsletter', published_at: 2.days.ago)

    get newsletters_path

    assert_response :success
    assert_select 'h2', text: 'Newer Newsletter'
    assert_select 'h2', text: 'Older Newsletter'

    response_body = response.body
    newer_position = response_body.index('Newer Newsletter')
    older_position = response_body.index('Older Newsletter')
    assert newer_position < older_position, 'Newer newsletter should appear before older newsletter'
  end

  test 'only displays newsletters with published_at' do
    create(:newsletter, title: 'Published Newsletter', published_at: 1.day.ago)
    create(:newsletter, title: 'Draft Newsletter', published_at: nil)

    get newsletters_path

    assert_response :success
    assert_select 'h2', text: 'Published Newsletter'
    assert_not_select 'h2', text: 'Draft Newsletter'
  end

  test 'renders newsletter body as markdown' do
    create(:newsletter, title: 'Test Newsletter', body: '# Hello World', published_at: Time.zone.now)

    get newsletters_path

    assert_response :success
    assert_select 'h1', text: 'Hello World'
  end

  test 'displays newsletter publication date' do
    create(:newsletter, title: 'Test Newsletter', published_at: Time.zone.local(2024, 1, 15))

    get newsletters_path

    assert_response :success
    assert_select 'time[datetime=?]', '2024-01-15T00:00:00Z'
  end
end
