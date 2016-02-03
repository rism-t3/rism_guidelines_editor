ActiveAdmin.register Original, :as => 'Guideline' do
  actions :all, :except => [:destroy, :show]
  permit_params :tag, :helptext, :translation

  config.sort_order = "updated_at_desc"

  filter :tag
  filter :helptext, :label => 'Guideline Text'
  filter :translations_help_text_cont, :label => 'Translation Text'
  filter :translations_language_cont, :label => 'Language', :as => :select, :collection => App::LANGUAGES

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
        link_to image_tag("en.png", size: "16x16"), edit_admin_guideline_path(r)
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
    inputs 'English' do
      input :tag
      if f.object.new_record?
        input :helptext, :as => :html_editor
      else
        input :helptext, :as => :html_editor, :input_html => {:value => File.read(resource.filename) }# resource.read_helpfile em
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
