class Document < ActiveRecord::Base
  before_save :make_content_dos_compatible
  after_save :set_filename, :write_helpfile
  before_create :set_filename

  before_destroy do
    self.versions.destroy_all
  end
  belongs_to :language
  belongs_to :template, class_name: 'Document', foreign_key: 'template_id' 
  has_many :translations, class_name: 'Document', foreign_key: 'template_id' 
  accepts_nested_attributes_for :template, :language
  
  scope :marc, ->{where('tag REGEXP ?', '[0-9]{3}')}
  scope :en, ->{where(:language => Language.where(:code => App::REFERENCE_LANGUAGE).take)}

  has_paper_trail

  def to_s
    return tag
  end

  def reference_helptext
    return File.read(template.filename)
  end
 
  def make_content_dos_compatible
    content.gsub!("\r\n", "\n")
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

  def self.add(str)
    str = "#{App::HELP_FILES}#{File.basename(str)}"
    file = Helpfile.new(str)
    return "Excluded file" if App::EXCLUDED_FILES.include?(file.filename)
    unless Document.exists?(:filename => file.filename)
        Document.create(:tag => file.tag, :content => file.content, :language => Language.where(:code => file.language).take, :filename => str)
    end
    Logging.debug "Document #{str} added!"
  end

  def self.modify(str)
    str = "#{App::HELP_FILES}#{File.basename(str)}"
    helpfile = Helpfile.new(str)
    document = Document.where(:filename => str).take
    if document.content != helpfile.content
      document.update(:content => helpfile.content)
       document.versions.last.update(:whodunnit => 1)
    end
    Logging.debug "Document #{document.filename} modified!"
  end

  def self.insert_new
    #FIXME look if pool is in synch
      Dir["#{App::HELP_FILES}*.html"]
  end

  def has_diff_content?
    begin
      File.read(filename) == content ? false : true
    rescue
      false
    end
  end

  def is_outdated?
    return false if !template_id
    return template.updated_at > self.updated_at ? true : false
  end
end
