class Original < ActiveRecord::Base
  after_save :write_helpfile
  before_create :set_filename
  has_many :translations
  accepts_nested_attributes_for :translations
  def to_s
    return tag
  end

  def set_filename
    self.filename = "#{App::HELP_FILES}#{tag}_en.html"
  end

  def write_helpfile
    return 0 if !tag
    return 0 if helptext.empty?
    file = File.open(filename, 'w')
    file.write(helptext)
    file.close
  end




end
