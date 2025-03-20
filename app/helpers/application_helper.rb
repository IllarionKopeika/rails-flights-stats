module ApplicationHelper
  def locale_to_flag(locale)
    flags = {
      ru: 'fi fi-ru',
      en: 'fi fi-gb'
    }
    content_tag(:span, "", class: "flag-icon #{flags[locale.to_sym]}")
  end

  def duration(elapsed_time)
    return I18n.t('flights.not_available') if elapsed_time.is_a?(String)

    hours, mins = elapsed_time.divmod(60)
    parts = []
    parts << "#{hours} #{I18n.t('flights.hours')}" if hours.positive?
    parts << "#{mins} #{I18n.t('flights.mins')}" if mins.positive?
    parts.join(" ")
  end
end
