# frozen_string_literal: true

class ProfileLinkComponent < ViewComponent::Base
  MASTODON_HOSTS = [
    'mastodon.social'
  ].freeze

  def initialize(link:)
    @link = link
  end

  def icon
    if MASTODON_HOSTS.include?(link_host)
      'icons/mastodon.svg'
    else
      'icons/link.svg'
    end
  end

  def alt
    if MASTODON_HOSTS.include?(link_host)
      'mastodon'
    else
      'link'
    end
  end

  def link_url
    @link.url
  end

  def link_text
    if MASTODON_HOSTS.include?(link_host)
      "@#{link_host}#{link_path}"
    else
      link_host
    end
  end

  private

  def link_host
    uri.host
  end

  def link_path
    uri.path
  end

  def uri
    URI.parse(link_url)
  end
end
