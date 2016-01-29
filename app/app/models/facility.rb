class Facility < ActiveRecord::Base
  after_save :write_helpfile

  def get_language_code(l)
    langs={"English" => 'en', "German" => 'de', "French" => "fr", "Italian" => "it"}
    return langs[l]
  end

  def filename
    "#{App::HELP_FILES}#{marc_field}_#{get_language_code(language)}.html"
  end

  def reference_filename
    "#{App::HELP_FILES}#{marc_field}_en.html"
  end

  def read_helpfile
    return "" if !name
    return File.read(filename)
  end

  def read_reference
    return "" if !name
    return File.read(reference_filename)
  end

  def write_helpfile
    return 0 if !name
    file = File.open(filename, 'w')
    file.write(help_text)
    file.close
  end




end
