ActiveAdmin.register Translation do

  menu false
  permit_params :marc_field_id, :language, :entity, :help_text

  scope :german
  scope :italian
  scope :french

  controller do
    def edit
      @page_title = "#{resource.marc_field.tag}-#{resource.language.upcase}"
    end

    def update
      update! do |format|
        format.html { redirect_to admin_marc_fields_path } if resource.valid?
      end
    end
    def create
      create! do |format|
         format.html { redirect_to admin_marc_fields_path } if resource.valid?
      end
    end
  end

  form do |f|
    f.inputs 'Translation' do
      f.input :marc_field_id, :as => :hidden
      if !f.object.new_record?
        f.input :language, :as => :select, :collection => %w(de es fr it), :input_html => { :disabled=>true }, :include_blank => false
      else
        f.input :language, :as => :select, :collection => %w(de es fr it) - resource.marc_field.translations.map(&:language), :include_blank => false
      end
      #input :entity, :as => :select, :collection => %w(Source Person Institution Catalogue)
      #f.input :reference_helptext, :as => :text, :input_html => {:style => 'background-color:#F5FFFA', :disabled => true, :readonly => true } if resource.marc_field
      f.input :reference_helptext, :as => :text if resource.marc_field
      #f.input 'Reference', :as => :text, :input_html => {:style => 'background-color:#F5FFFA', :value => raw(resource.marc_field.read_helpfile), :disabled => true, :readonly => true }, :readonly => true if resource.marc_field
      if !resource.help_text
        f.input :help_text, :as => :html_editor, :input_html => {:value => "[TO TRANSLATE:] #{resource.marc_field.read_helpfile.html_safe }"} if resource.marc_field
      else
        f.input :help_text, :as => :html_editor, :input_html => {:value => resource.read_helpfile } if resource.marc_field# resource.read_helpfile emd
      end
dd
      f.actions
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
