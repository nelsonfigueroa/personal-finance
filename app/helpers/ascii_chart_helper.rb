# frozen_string_literal: true

module AsciiChartHelper
  FILLED = "\u2588" # █
  EMPTY  = "\u2591" # ░
  BAR_WIDTH = 30

  # Renders a horizontal bar chart using Unicode block characters.
  #
  # data: Hash of { label => numeric_value }
  # options:
  #   prefix: string prepended to values (default: "$")
  #   colors: Hash of { label => css_class } for per-bar coloring
  #   show_percent: boolean, show percentage of max (default: false)
  #   total: numeric, if provided percentages are calculated against this instead of max
  def ascii_bar(data, options = {})
    return content_tag(:p, "No data.", class: "ascii-chart-empty") if data.nil? || data.empty?

    prefix = options[:prefix] || "$"
    colors = options[:colors] || {}
    show_percent = options[:show_percent] || false
    total = options[:total]
    max_value = data.values.max.to_f

    return content_tag(:p, "No data.", class: "ascii-chart-empty") if max_value <= 0

    content_tag(:div, class: "ascii-chart") do
      safe_join(
        data.map do |label, value|
          ratio = max_value > 0 ? (value / max_value) : 0
          filled_count = (ratio * BAR_WIDTH).round
          empty_count = BAR_WIDTH - filled_count

          bar_str = (FILLED * filled_count) + (EMPTY * empty_count)
          formatted_value = "#{prefix}#{number_with_delimiter(format('%.2f', value))}"

          color_class = colors[label] || "ascii-bar-green"

          percent_str = if show_percent && total && total > 0
                          pct = (value / total.to_f * 100).round
                          content_tag(:span, "#{pct}%", class: "ascii-chart-percent")
                        elsif show_percent && max_value > 0
                          pct = (value / max_value * 100).round
                          content_tag(:span, "#{pct}%", class: "ascii-chart-percent")
                        else
                          "".html_safe
                        end

          content_tag(:div, class: "ascii-chart-row") do
            content_tag(:span, label.to_s.downcase, class: "ascii-chart-label") +
            content_tag(:span, bar_str, class: "ascii-chart-bar #{color_class}") +
            content_tag(:span, formatted_value, class: "ascii-chart-value") +
            percent_str
          end
        end
      )
    end
  end
end
