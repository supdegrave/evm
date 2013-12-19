# Use this setup block to configure all options available in SimpleForm.
# SimpleForm.setup do |config|
#   config.wrappers :foundation, class: :input, hint_class: :field_with_hint, error_class: :error do |b|
#     b.use :html5
#     b.use :placeholder
#     b.optional :maxlength
#     b.optional :pattern
#     b.optional :min_max
#     b.optional :readonly
#     b.use :label_input
#     b.use :error, wrap_with: { tag: :small }
# 
#     # Uncomment the following line to enable hints. The line is commented out by default since Foundation
#     # does't provide styles for hints. You will need to provide your own CSS styles for hints.
#     # b.use :hint,  wrap_with: { tag: :span, class: :hint }
#   end
# 
#   # CSS class for buttons
#   config.button_class = 'button'
# 
#   # CSS class to add for error notification helper.
#   config.error_notification_class = 'alert-box alert'
# 
#   # The default wrapper to be used by the FormBuilder.
#   config.default_wrapper = :foundation
# end

SimpleForm.setup do |config|
  config.wrappers :default, class: 'input row', hint_class: :field_with_hint, error_class: :errors do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    ## Inputs
    b.wrapper tag: :div, class: 'large-16 small-16 columns' do |c|
      c.wrapper tag: :div, class: 'row collapse' do |d|
        d.wrapper tag: :div, class: 'large-4 small-4 columns' do |e|
          e.use :label, wrap_with: {tag: :span, class: :prefix}
        end
        d.wrapper tag: :div, class: 'large-12 small-12 columns' do |e|
          e.use :input
        end
      end
      c.wrapper tag: :div, class: 'row collapse' do |d|
        d.wrapper tag: :div, class: 'large-16 small-16 columns' do |e|
          e.use :hint,  wrap_with: { tag: :span, class: :hint }
          e.use :error, wrap_with: { tag: :small, class: :error }
        end
      end
    end
  end
  config.default_wrapper = :default
  config.boolean_style = :nested
  config.button_class = 'button'
  config.error_notification_tag = :div
  config.error_notification_class = 'alert-box alert'
  config.label_class = 'control-label'
  config.form_class = :nice
  config.browser_validations = false
end