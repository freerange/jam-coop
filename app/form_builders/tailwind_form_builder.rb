# frozen_string_literal: true

class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  class_attribute :text_field_helpers,
                  default: field_helpers - %i[label check_box radio_button fields_for fields hidden_field file_field]
  #  leans on the FormBuilder class_attribute `field_helpers`
  #  you'll want to add a method for each of the specific helpers listed here if you want to style them

  TEXT_FIELD_STYLE = 'border border-slate-200 outline-none px-3 py-2'
  SELECT_FIELD_STYLE = 'block'
  SUBMIT_BUTTON_STYLE = 'py-3 px-5 bg-amber-500 hover:bg-amber-400 text-white font-medium cursor-pointer'

  text_field_helpers.each do |field_method|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1 # rubocop:disable Style/DocumentDynamicEvalDefinition
          def #{field_method}(method, options = {})
            if options.delete(:tailwindified)
              super
            else
              text_like_field(#{field_method.inspect}, method, options)
            end
          end
    RUBY_EVAL
  end

  def submit(value = nil, options = {})
    custom_opts, opts = partition_custom_opts(options)
    classes = apply_style_classes(SUBMIT_BUTTON_STYLE, custom_opts)

    super(value, { class: classes }.merge(opts))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &)
    custom_opts, opts = partition_custom_opts(options)
    classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

    labels = labels(method, custom_opts[:label], options)
    field = super(method, choices, opts, html_options.merge({ class: classes }), &)

    labels + field
  end

  def currency_field(object_method, options = {})
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts, object_method)

    field = send(:text_field, object_method, {
      class: classes,
      title: errors_for(object_method)&.join(' ')
    }.compact.merge(opts).merge({ tailwindified: true }))

    labels = labels(object_method, custom_opts[:label], options)

    symbol = @template.content_tag('span', opts[:symbol] || '£')
    prefix = @template.content_tag('div', symbol, class: 'flex justify-center items-center mb-2 px-2 bg-slate-200')
    field_wrapper = @template.content_tag('div', prefix + field, class: 'flex')

    labels + field_wrapper
  end

  def labels(object_method, label_options = {}, field_options = {})
    label = tailwind_label(object_method, label_options, field_options)
    error_label = error_label(object_method, field_options)

    @template.content_tag('div', label + error_label, { class: 'flex flex-col items-start' })
  end

  private

  def text_like_field(field_method, object_method, options = {})
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts, object_method)

    field = send(field_method, object_method, {
      class: classes,
      title: errors_for(object_method)&.join(' ')
    }.compact.merge(opts).merge({ tailwindified: true }))

    labels = labels(object_method, custom_opts[:label], options)

    labels + field
  end

  def tailwind_label(object_method, label_options, field_options)
    text, label_opts = if label_options.present?
                         [label_options[:text], label_options.except(:text)]
                       else
                         [nil, {}]
                       end

    label_classes = label_opts[:class] || 'block text-slate-600 mb-1 md:mb-0 pr-4'
    label_classes += ' text-yellow-800 dark:text-yellow-400' if field_options[:disabled]
    label(object_method, text, {
      class: label_classes
    }.merge(label_opts.except(:class)))
  end

  def error_label(object_method, options)
    return if errors_for(object_method).blank?

    error_message = @object.errors.full_messages_for(object_method).to_sentence
    tailwind_label(object_method, { text: error_message, class: ' font-bold text-red-500' }, options)
  end

  def border_color_classes(object_method)
    if errors_for(object_method).present?
      ' border-2 border-red-400 focus:border-rose-200'
    else
      ' border border-gray-300 focus:border-yellow-700'
    end
  end

  def apply_style_classes(classes, custom_opts, object_method = nil)
    classes + border_color_classes(object_method) + " #{custom_opts[:class]}"
  end

  CUSTOM_OPTS = %i[label class].freeze
  def partition_custom_opts(opts)
    opts.partition { |k, _v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
  end

  def errors_for(object_method)
    return unless @object.present? && object_method.present?

    @object.errors[object_method]
  end
end
