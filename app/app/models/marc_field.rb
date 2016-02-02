class MarcField < ActiveRecord::Base
  after_save :write_helpfile
  has_many :translations
  accepts_nested_attributes_for :translations
  def to_s
    return tag
  end

  def filename
    "#{App::HELP_FILES}#{tag}_en.html"
  end

  def read_helpfile
    return "" if !File.exists?(filename)
    return File.read(filename)
  end

  def write_helpfile
    return 0 if !tag
    return 0 if helptext.empty?
    file = File.open(filename, 'w')
    file.write(helptext)
    file.close
  end




end
