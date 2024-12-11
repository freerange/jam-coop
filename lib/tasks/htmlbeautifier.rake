# frozen_string_literal: true

desc 'Run htmlbeautifier'
task htmlbeautifier: :environment do
  files = Rails.root.glob('app/**/*.html.erb') +
          Rails.root.glob('test/**/*.html.erb')

  cmd = "bundle exec htmlbeautifier -b1 -l #{files.join(' ')}"

  _stdout, stderr, status = Open3.capture3(cmd)

  raise "htmlbeautifier failed with #{stderr}" unless status.success?
end
