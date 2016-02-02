class Translation < ActiveRecord::Base
  before_create :set_filename
  after_save :write_helpfile
  belongs_to :original

  scope :german, -> {where(:language => 'de')}
  scope :italian, -> {where(:language => 'it')}
  scope :french, -> {where(:language => 'fr')}

  def set_filename
    self.filename = "#{App::HELP_FILES}#{original.tag}_#{language}.html"
  end

  def reference_helptext
    return File.read(original.filename)
  end

  def write_helpfile
      f = File.open(filename, "w")
      f.write(help_text)
      f.close
  end

end
