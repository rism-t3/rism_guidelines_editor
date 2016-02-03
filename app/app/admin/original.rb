ActiveAdmin.register Original, :as => 'Guideline' do
  #scope :german
  #scope :french
  #scope :spanish
  #scope :italian
  #scope :all
  permit_params :tag, :helptext, :translation

  #action_item :translate, only: :index do
  #    link_to 'translate', new_admin_translation_path
  #end
  config.sort_order = "updated_at_desc"

  filter :tag
  filter :helptext, :label => 'Guideline Text'
  filter :translations_help_text_cont, :label => 'Translation Text'
  filter :translations_language_cont, :label => 'Language', :as => :select, :collection => %w(de es fr it)

  index do
    selectable_column
    column :tag
    column :translations do |r|
      r.translations.order(:language).each.map do |t|
#        link_to(t.language, edit_admin_translation_path(t)) 
        #
        link_to image_tag("#{t.language}.png"), edit_admin_translation_path(t)
      end.join(' ').html_safe
    end
    actions defaults: true do |r|
        link_to "Translate", new_admin_translation_path(:translation => { :original_id => r.id })
     end
  end

  form do |f|
    inputs 'English' do
      input :tag
      if f.object.new_record?
        input :helptext, :as => :html_editor# resource.read_helpfile emd
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
