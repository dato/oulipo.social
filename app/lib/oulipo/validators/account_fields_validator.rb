# coding: utf-8
# frozen_string_literal: true

module Oulipo
  class Validators::AccountFieldsValidator < ActiveModel::Validator

    def validate(account)
      if account.local?
        account.fields.each do |field|
          validate_text(field, account)
        end
      end
    end

    private

    def validate_text(field, account)
      [field.name, field.value].each do |text|
        [Oulipo::URL_REGEX, Oulipo::MENTION_REGEX, Oulipo::EMOJI_REGEX].each do |regex|
          text = text.gsub(regex, '')
        end
        if text.match?(Oulipo::FIFTH_GLYPH_REGEX)
          account.errors.add(:base, 'Bio Tags (look down) contain an invalid symbol')
        end
      end
    end

  end
end
