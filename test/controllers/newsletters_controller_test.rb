# frozen_string_literal: true

require 'test_helper'

class NewslettersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get newsletters_path
    assert_response :success
  end

  test 'displays newsletters in reverse chronological order' do
    create(:newsletter, title: 'Older Newsletter', created_at: 2.days.ago)
    create(:newsletter, title: 'Newer Newsletter', created_at: 1.day.ago)

    get newsletters_path

    assert_response :success
    assert_select 'h2', text: 'Newer Newsletter'
    assert_select 'h2', text: 'Older Newsletter'

    response_body = response.body
    newer_position = response_body.index('Newer Newsletter')
    older_position = response_body.index('Older Newsletter')
    assert newer_position < older_position, 'Newer newsletter should appear before older newsletter'
  end

  test 'renders newsletter body as markdown' do
    create(:newsletter, title: 'Test Newsletter', body: '# Hello World')

    get newsletters_path

    assert_response :success
    assert_select 'h1', text: 'Hello World'
  end

  test 'displays newsletter creation date' do
    create(:newsletter, title: 'Test Newsletter', created_at: Time.zone.local(2024, 1, 15))

    get newsletters_path

    assert_response :success
    assert_select 'time[datetime=?]', '2024-01-15T00:00:00Z'
  end
end
