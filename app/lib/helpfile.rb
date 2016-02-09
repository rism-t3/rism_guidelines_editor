class Helpfile

  attr_accessor :language, :tag, :content, :filename

  def initialize(str)
    file = File.open(str)
    lang = File.basename(file.path).gsub(/^\S+_([a-z]{2})\.html/, '\1')
    @language = lang ? lang : ""
    marc = File.basename(file.path).gsub(/^(\w+)_\S+$/, '\1')
    @tag = marc ? marc : ""
    @content = File.read(str)
    @filename = str

  end

end
