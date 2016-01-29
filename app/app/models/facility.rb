class Facility < ActiveRecord::Base
  after_save :write_helpfile
  belongs_to :marc_field

  scope :german, -> {where(:language => 'German')}
  scope :italian, -> {where(:language => 'Italian')}
  scope :french, -> {where(:language => 'French')}

  def get_language_code(l)
    langs={"German" => 'de', "French" => "fr", "Italian" => "it"}
    return langs[l]
  end

  def filename
    "#{App::HELP_FILES}#{marc_field.tag}_#{get_language_code(language)}.html"
  end

  def reference_filename
    "#{App::HELP_FILES}#{marc_field.tag}_en.html"
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
    if !File.exist?(filename)
      f = File.open(filename, "w")
      f.write("[to translate: ]\n" + marc_field.read_helpfile)
      f.close
    else
      return 0 if !help_text || help_text.empty?
      file = File.open(filename, 'w')
      file.write(help_text)
      file.close
    end
  end




end
