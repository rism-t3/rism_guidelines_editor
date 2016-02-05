ActiveAdmin.register Translation do

  menu false
  permit_params :original_id, :language, :entity, :content

  scope :german
  scope :italian
  scope :french
  sidebar :versions, :only => :edit, :if => proc{!Translation.find(params[:id]).versions.where(:event => 'update').empty?} do
    puts params
    table_for PaperTrail::Version.where(:item_id => resource.id).where(:event => 'update').order('id desc').limit(5) do # Use PaperTrail::Version if this throws an error
      column "Item" do  |v| link_to v.id, edit_admin_translation_path(:version => v.id) end
      column "Modified at" do |v| v.created_at.to_s :long end
      column "Admin" do |v| link_to AdminUser.find(v.whodunnit).email, admin_admin_user_path(v.whodunnit) end
      end
    link_to "Return to current version", edit_admin_translation_path
  end

  sidebar :help, :only => :edit do
    render :partial => "shared/help"
#    ul do
#      li "To edit a translation please click on flag icon at \"Edit\" column."
#      li "To create a new translation click on flag icon at \"Add New Translation\" column."
#      li "Flag blinking indicates that the reference guideline is newer than the existent translation."
#      li "A view of the reference guideline is provided by edit and create action."
#    end
  end

  controller do
    def edit
      @page_title = "#{resource.original.tag}-#{resource.language.upcase}"
    end

    def update
      update! do |format|
        format.html { redirect_to admin_guidelines_path } if resource.valid?
      end
    end
    def create
      create! do |format|
         format.html { redirect_to admin_guidelines_path } if resource.valid?
      end
    end
  end

  form do |f|
    f.inputs 'Translation' do
      f.input :original_id, :as => :hidden
      f.input :language, :as => :hidden
      #if !f.object.new_record?
      #  f.input :language, :as => :select, :collection => App::LANGUAGES, :input_html => { :disabled=>true }, :include_blank => false
      #else
      #  f.input :language, :as => :select, :collection => App::LANGUAGES - resource.original.translations.map(&:language), :include_blank => false
      #end
      #input :entity, :as => :select, :collection => %w(Source Person Institution Catalogue)
      #f.input :reference_helptext, :as => :text, :input_html => {:style => 'background-color:#F5FFFA', :disabled => true, :readonly => true } if resource.marc_field
      f.input :reference_helptext, :as => :text if resource.original
      #f.input 'Reference', :as => :text, :input_html => {:style => 'background-color:#F5FFFA', :value => raw(resource.marc_field.read_helpfile), :disabled => true, :readonly => true }, :readonly => true if resource.marc_field
      if !resource.content
        f.input :content, :as => :html_editor, :input_html => {:value => "[TO TRANSLATE:] #{File.read(resource.original.filename) }"} if resource.original
      else
        previous_version = resource.versions.where(:id => params[:version]).take
        previous = previous_version ? previous_version.reify.content : File.read(resource.filename)
        f.input :content, :as => :html_editor, :input_html => {:value => File.read(resource.filename).html_diff(previous) } if resource.original# resource.read_helpfile emd
      end
dd
      f.actions do
        f.action(:submit)
        f.cancel_link(admin_guidelines_path)
      end
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
