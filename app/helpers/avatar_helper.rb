module AvatarHelper
  def avatar name, url, size="md"
    words = name.split
    initials = words[0][0]
    if(words[1].present?)
      initials += words[1][0]
    end

    color = ["#8a2be2", "#472be2", "#2b8ee2", "#22afa2", "#22af2d", "#af9122", "#af2f22", "#af2222", "#af2284"]

    # return File.exist?(url.url)
    if(url.present?)
      html = "<figure style=\"background-image:url('#{url}')\" class=\"avatar avatar-#{size}\"></figure>"
    else
      html = "<figure style=\"background-color: #{color.sample};\" class=\"avatar avatar-#{size}\">#{initials.upcase}</figure>"
    end

    html.html_safe;

  end

end
