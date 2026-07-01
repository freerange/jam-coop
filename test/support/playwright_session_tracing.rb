# frozen_string_literal: true

module PlaywrightSessionTracing
  ROOT_PATH = Rails.root.join('tmp/playwright-traces')

  def after_setup
    super

    start_tracing(session_name: 'default', session: Capybara.current_session)
  end

  def before_teardown
    super

    Capybara.send(:session_pool).each do |name, session|
      session_name = name.split(':')[1].underscore
      stop_tracing(session_name:, session:, save: failed?)
    end
  end

  def using_session(session_name, &block)
    super do
      start_tracing(session_name:, session: Capybara.current_session)
      block.call(session_name)
    end
  end

  def start_tracing(session_name:, session:)
    @session_names ||= Set.new
    unless @session_names.include?(session_name)
      session.driver.start_tracing(
        name: trace_name(session_name),
        title: trace_name(session_name),
        screenshots: true,
        snapshots: true
      )
    end
    @session_names << session_name
  end

  def stop_tracing(session_name:, session:, save:)
    if save
      FileUtils.mkdir_p(ROOT_PATH)
      path = ROOT_PATH.join("#{trace_name(session_name)}.zip")
      session.driver.stop_tracing(path: path)
    else
      session.driver.stop_tracing
    end
  end

  def trace_name(session_name)
    "#{self.class}-#{name}-#{session_name}"
  end
end
