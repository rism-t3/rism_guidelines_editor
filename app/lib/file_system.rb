class FileSystem
  attr_accessor :files

  def initialize
    @files = Dir["#{App::HELP_FILES}*.html"]
  end

  def sort_by_reference_language
    result = []
    files.each do |f|
      file = Helpfile.new(f)
      if file.language == App::REFERENCE_LANGUAGE
        result.unshift(file)
      else
        result << file
      end
    end
    return result
  end
end

