ActiveAdmin.register Original, :as => 'Guideline' do

  config.clear_action_items!
  action_item :view, :if => proc { current_admin_user.can_edit?("en") } do
          link_to 'New Guideline', new_admin_guideline_path
  end
  
  permit_params :tag, :content, :translation

  config.sort_order = "updated_at_desc"

  filter :content_or_translations_content_cont, :label => 'Guideline Text'
  filter :translations_language_cont, :label => 'Language', :as => :select, :collection => App::LANGUAGES
  filter :tag

  controller do 
    def update
      #@versions = resource.versions
      update! do |format|
       format.html { redirect_to collection_path } if resource.valid?
      end
    end
  end

  sidebar :versions, :only => :edit, :if => proc{!Original.find(params[:id]).versions.where(:event => 'update').empty?} do
  #sidebar :versions, :only => :edit do
    table_for PaperTrail::Version.where(:item_id => resource.id).where(:event => 'update').order('id desc').limit(5) do # Use PaperTrail::Version if this throws an error
      column "Item" do  |v| link_to v.id, edit_admin_guideline_path(:version => v.id) end
      column "Modified at" do |v| v.created_at.to_s :long end
      column "Admin" do |v| link_to AdminUser.find(v.whodunnit).email, admin_admin_user_path(v.whodunnit) end
      end
    link_to "Return to current version", edit_admin_guideline_path
  end

  sidebar :help do
    ul do
      li "To edit a translation please click on flag icon at \"Edit\" column."
      li "To create a new translation click on flag icon at \"Add New Translation\" column."
      li "Flag blinking indicates that the reference guideline is newer than the existent translation."
      li "A view of the reference guideline is provided by edit and create action."
    end
  end
  index do
    selectable_column
    column :tag
    column 'Edit' do |r|
      r.translations.order(:language).each.map do |t|
        if !t.is_outdated?
          link_to image_tag("#{t.language}.png", size: "16x16"), edit_admin_translation_path(t) if current_admin_user.can_edit?(t)
        else
          link_to image_tag("#{t.language}.png", size: "16x16", :class => 'blink_image'), edit_admin_translation_path(t) if current_admin_user.can_edit?(t)
        end
      end.unshift(
      if current_admin_user.can_edit?("en")
        if r.has_diff_content?
          link_to image_tag("en.png", size: "16x16", :class => 'blink_image'), edit_admin_guideline_path(r)
        else
          link_to image_tag("en.png", size: "16x16"), edit_admin_guideline_path(r)
        end
      end      
      ).join(' ').html_safe
    end
    column :updated_at
    column :add_new_translation do |r|
      (App::LANGUAGES - r.translations.map(&:language)).each.map do |l|
        link_to image_tag("#{l}.png", size: "16x16"), new_admin_translation_path(:translation => { :original_id => r.id, :language => l }) if current_admin_user.can_edit?(l) 
      end.join(' ').html_safe
    end
  end

  form do |f|
    #unless resource.diff_content.empty?

     # panel 'diff' do
       # div do
      #         span resource.diff_content.html_safe
        #  end
       # end
   # end

    inputs 'English' do
      input :tag
      puts params
      if f.object.new_record?
        input :content, :as => :html_editor
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
