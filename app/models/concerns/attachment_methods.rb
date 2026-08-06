# frozen_string_literal: true

module AttachmentMethods
  extend ActiveSupport::Concern

  class_methods do
    def validates_original_audio(attribute, required: false)
      options = {
        content_type: {
          in: OriginalAudio.content_types,
          message: "must be an audio file (#{OriginalAudio.file_types.join(', ')})"
        }
      }
      options[:attached] = { message: 'file cannot be missing' } if required

      validates(attribute, options)
    end

    def validates_image(attribute, required: false)
      options = {
        content_type: {
          in: Image.content_types,
          message: "must be an image file (#{Image.file_types.join(', ')})"
        }
      }
      options[:attached] = { message: 'file cannot be missing' } if required

      validates(attribute, options)
    end
  end
end
