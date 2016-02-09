class Helpfile < File

  def language
    lang=File.basename(self.path).gsub(/^\S+_([a-z]{2})\.html/, '\1')
    lang ? lang : ""
  end

  def tag
    marc=File.basename(self.path).gsub(/^(\w+)_\S+$/, '\1')
    marc ? marc : ""
  end

  def content
    File.read(self)
  end




end
