module ApplicationHelper
  require 'date'

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

  def format_date(date, locale = I18n.locale)
    date = Date.strptime(date, "%Y-%m-%d")
    I18n.l(date, format: :short, locale: locale)
  end

  def date_comparison(departure, arrival)
    departure_date = Date.parse(departure)
    arrival_date = Date.parse(arrival)
    arrival_date > departure_date
  end

  def days_to_flight(departure_date)
    (Date.parse(departure_date) - Date.today).to_i
  end

  def pluralize_days(count)
    locale = I18n.locale
    if locale == :ru
      russian_pluralize(count, "день", "дня", "дней")
    else
      count == 1 ? "day" : "days"
    end
  end

  private

  def russian_pluralize(count, one, few, many)
    return many if (count % 100).between?(11, 14)
    case count % 10
    when 1 then one
    when 2..4 then few
    else many
    end
  end
end
