# frozen_string_literal: true

module AttachmentMethods
  extend ActiveSupport::Concern

  class_methods do
    def validates_original_audio(attribute, required: false)
      options = {
        content_type: {
          in: OriginalAudio.content_types,
          spoofing_protection: true,
          message: "must be an audio file (#{OriginalAudio.file_types.join(', ')})"
        },
        size: {
          less_than: 1.gigabyte
        },
        processable_file: true
      }
      options[:attached] = { message: 'file cannot be missing' } if required

      validates(attribute, options)
    end

    def validates_image(attribute, required: false)
      options = {
        content_type: {
          in: GenericImage.content_types,
          spoofing_protection: true,
          message: "must be an image file (#{GenericImage.file_types.join(', ')})"
        },
        size: {
          less_than: 75.megabytes
        },
        processable_file: true
      }
      options[:attached] = { message: 'file cannot be missing' } if required

      validates(attribute, options)
    end
  end
end
