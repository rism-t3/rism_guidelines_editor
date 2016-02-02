class Translation < ActiveRecord::Base
  after_save :write_helpfile
  belongs_to :marc_field

  scope :german, -> {where(:language => 'de')}
  scope :italian, -> {where(:language => 'it')}
  scope :french, -> {where(:language => 'fr')}

  def filename
    "#{App::HELP_FILES}#{marc_field.tag}_#{language}.html"
  end

  def reference_filename
    "#{App::HELP_FILES}#{marc_field.tag}_en.html"
  end

  def synchronize
    puts File.read(filename) == help_text

  end

  def reference_helptext
    return marc_field.helptext
  end

  def read_helpfile
    return "" if !marc_field
    return "" if !language
    return File.read(filename)
  end

  def read_reference
    return "" if !name
    return File.read(reference_filename)
  end

  def write_helpfile
    if !File.exist?(filename) && help_text.empty?
      f = File.open(filename, "w")
      f.write("[to translate: ]\n" + marc_field.read_helpfile)
      f.close
    elsif !help_text.empty?
      f = File.open(filename, "w")
      f.write(help_text)
      f.close
    else
      return 0 if !help_text || help_text.empty?
      file = File.open(filename, 'w')
      file.write(help_text)
      file.close
    end
  end




end
