module ApplicationHelper
  def locale_to_flag(locale)
    flags = {
      ru: 'fi fi-ru',
      en: 'fi fi-gb'
    }
    content_tag(:span, "", class: "flag-icon #{flags[locale.to_sym]}")
  end
end
