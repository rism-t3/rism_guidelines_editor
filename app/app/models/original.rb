class Original < ActiveRecord::Base
  scope :spanish, -> {joins(:translations).where('translations.language="es"')}
  scope :french, -> {joins(:translations).where('translations.language="fr"')}
  scope :italian, -> {joins(:translations).where('translations.language="it"')}
  scope :german, -> {joins(:translations).where('translations.language="de"')}
  after_save :write_helpfile
  before_create :set_filename
  before_destroy do
    self.versions.destroy_all
  end
  has_many :translations
  accepts_nested_attributes_for :translations

  has_paper_trail

  def to_s
    return tag
  end

  def set_filename
    self.filename = "#{App::HELP_FILES}#{tag}_en.html"
  end

  def write_helpfile
    return 0 if !tag
    return 0 if content.empty?
    file = File.open(filename, 'w')
    file.write(content)
    file.close
  end

  def self.is_sync?
    #riginal
  end

  def has_diff_content?
    File.read(filename)==content ? false : true
  end

  #def diff_content
  #  filecontent = File.read(filename)
  #  modelcontent = content
  #  Diffy::Diff.new(filecontent, modelcontent, :allow_empty_diff => false).to_s#(:html)
  #end

  def to_nodes
    require 'nokogiri'
    Nokogiri::HTML(self.content)
  end




end
