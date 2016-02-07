class Document < ActiveRecord::Base

  after_save :set_filename, :write_helpfile

  before_destroy do
    self.versions.destroy_all
  end
  belongs_to :language
  belongs_to :template, class_name: 'Document', foreign_key: 'template_id' 
  has_many :translations, class_name: 'Document', foreign_key: 'template_id' 
  accepts_nested_attributes_for :template, :language

  has_paper_trail

  def to_s
    return tag
  end

  def reference_helptext
    return File.read(template.filename)
  end
  
  def is_reference_document?
    language.code == App::REFERENCE_LANGUAGE ? true : false
  end

  def set_filename
    self.filename = "#{App::HELP_FILES}#{tag}_#{language.code}.html"
  end

  def write_helpfile
    return 0 if !tag
    return 0 if content.empty?
    file = File.open(filename, 'w')
    file.write(content)
    file.close
    template.touch if template;
  end

  def self.is_sync?
    #riginal
  end

  def has_diff_content?
    File.read(filename)==content ? false : true
  end

end
