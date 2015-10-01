module ApipieHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def heading(title, level=1)
    content_tag("h#{level}") do
      title
    end
  end

end