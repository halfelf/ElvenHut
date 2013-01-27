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

  class ::Hash
    def to_struct struct_name = nil
      Struct.new(struct_name, *keys).new(*values)
    end
  end
end
