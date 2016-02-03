class Original < ActiveRecord::Base
  scope :spanish, -> {joins(:translations).where('translations.language="es"')}
  scope :french, -> {joins(:translations).where('translations.language="fr"')}
  scope :italian, -> {joins(:translations).where('translations.language="it"')}
  scope :german, -> {joins(:translations).where('translations.language="de"')}
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

  def self.is_sync?
    #riginal
  end




end
