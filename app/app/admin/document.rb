ActiveAdmin.register Document do

  config.clear_action_items!
  action_item :view, :if => proc { current_admin_user.can_edit?("en") } do
          link_to 'New Document', new_admin_document_path
  end
  
  permit_params :tag, :content, :template_id, :language_id
  config.sort_order = "updated_at_desc"

  #before_filter do
  #         params.permit!
  #            end

  filter :content_or_translations_content_cont, :label => 'Guideline Text'
  #filter :translations_language_cont, :label => 'Language', :as => :select, :collection => App::LANGUAGES
  filter :tag

  collection_action :index, :method => :get do
    scope = Document.where(:template_id => nil)
    @collection = scope.page() if params[:q].blank?
    @search = scope.search(clean_search_params(params[:q]))
    respond_to do |format|
      format.html {
        render "active_admin/resource/index"
      }
    end
  end
 
  controller do
    #def index
      #def scoped_collection
       # Document.where(:template_id => nil)
      #end
      #@documents = Document.where(:template_id => nil)
    #end
    def edit
      if params[:version]
        flash.now[:warning] = "This is #{resource.versions.find(params[:version]).created_at} version"
      end
      @documents = Document.all
      puts params
      edit!
    end
    def update
      update! do |format|
       format.html { redirect_to collection_path } if resource.valid?
      end
    end
  end

  sidebar :versions, :only => :edit, :if => proc{!Document.find(params[:id]).versions.where(:event => 'update').empty?} do
    cnt = 0
  #sidebar :versions, :only => :edit do
    table_for PaperTrail::Version.where(:item_id => resource.id).where(:event => 'update').order('id desc').limit(5) do # Use PaperTrail::Version if this throws an error
      column "Item" do  |v| link_to cnt+=1, edit_admin_document_path(:version => v.id) end
      column "Modified at" do |v| v.created_at.to_s :long end
      column "Admin" do |v| link_to AdminUser.find(v.whodunnit).email, admin_admin_user_path(v.whodunnit) end
      end
    link_to "Return to current version", edit_admin_document_path
  end

  sidebar :help do
    render :partial => "shared/help"
  end
  index do
    selectable_column
    column :tag
    column 'Edit' do |r|
      r.translations.each.map do |t|
      #r.translations.order(:language).each.map do |t|
        if true
        #if !t.is_outdated?
          link_to image_tag(t.language.image, size: "16x16"), edit_admin_document_path(t) if current_admin_user.can_edit?(t)
        else
          link_to image_tag(t.language.image, size: "16x16", :class => 'blink_image'), edit_admin_document_path(t) if current_admin_user.can_edit?(t)
        end
      end.unshift(
      if current_admin_user.can_edit?(App::REFERENCE_LANGUAGE)
        if r.has_diff_content?
          link_to image_tag(r.image, size: "16x16", :class => 'blink_image'), edit_admin_document_path(r)
        else
          link_to image_tag(r.language.image, size: "16x16"), edit_admin_document_path(r)
        end
      end      
      ).join(' ').html_safe
    end
    column :updated_at
    column :add_new_translation do |r|
      (Language.where.not(:code => App::REFERENCE_LANGUAGE) - r.translations.map(&:language)).each.map do |l|
        link_to image_tag(l.image, size: "16x16"), new_admin_document_path(:document => {:tag => r.tag, :template_id => r.id, :language_id => l.id}) if current_admin_user.can_edit?(l) 
      end.join(' ').html_safe
    end
  end

  form do |f|
    inputs 'Documents' do
      input :tag
      f.input :template_id
      f.input :language_id#, :as => :hidden#, :include_blank => false
      f.input :reference_helptext, :as => :text if resource.template
      puts params
      if f.object.new_record?
        if params[:document]
          input :content, :as => :html_editor, :input_html => {:value => "[TO TRANSLATE: ] #{File.read(Document.find(params[:document][:template_id]).filename)}"} 
        else
          input :content, :as => :html_editor
        end
      else
        if params[:version]
          previous = resource.versions.where(:id => params[:version]).take.reify.content 
          puts resource.versions.where(:id => params[:version]).take
          input :content, :as => :html_editor, :input_html => {:value => resource.content.html_diff(previous) }# resource.read_helpfile em
        else
          input :content, :as => :html_editor#, :input_html => {:value => resource.diff_content }# resource.read_helpfile em
        end
        #input :helptext, :as => :html_editor, :input_html => {:value => File.read(resource.filename) }# resource.read_helpfile em
      end
      actions 
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
