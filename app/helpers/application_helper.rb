module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "base_title_placeholder"
    if page_title.blank?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end 

end