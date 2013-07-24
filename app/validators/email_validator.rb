require 'mail'
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || I18n.t('invalid', :scope => [:errors, :messages]) ) unless ActiveModel::EachValidator::EmailValidator.is_email?(value)
  end

  def self.is_email?(value)
    value =~ /([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@(([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6})$/i
  end
end
