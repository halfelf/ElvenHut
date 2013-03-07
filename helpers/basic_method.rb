# encoding: utf-8

module BasicMethods

  def current_folder?(path="")
    'class="active"' if request.path_info =~ Regexp.new(path)
  end

  def current_page?(path="")
    'class="active"' if request.path_info == path
  end

  def parse_date origin_date
    origin_date.strftime("%b %d, %Y")
  end

  def parse_year origin_date
    origin_date.strftime("%Y")
  end

  def parse_month_day origin_date
    origin_date.strftime("%d %B")
  end

  def get_title
    title = request.path_info.gsub(/\//, ' ').strip
    title << " | " if title != ""
  end

  def get_article_keywords article
    tag_names = []
    article.tags.sort!{|x, y| y.quantity <=> x.quantity }.each {|tag| tag_names << tag.name}
    tag_names.join(',')
  end

  class ::Hash
    def to_struct struct_name = nil
      Struct.new(struct_name, *keys).new(*values)
    end
  end
end
