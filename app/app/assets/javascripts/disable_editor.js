function enforceInactiveStates() {
        //this.composer.element.setAttribute('contenteditable', false);
        this.composer.disable();
        var disabled = this.textareaElement.disabled;
        var readonly = !!this.textareaElement.getAttribute('readonly');
        if (readonly) {
                this.composer.element.setAttribute('contenteditable', false);
                this.toolbar.commandsDisabled = true;
        }

        if (disabled) {
                this.composer.disable();
                //this.toolbar.commandsDisabled = true;
        }
}

$(document).ready( function() {
  if ($("#translation_reference_helptext").length) {
        var editor = new wysihtml5.Editor($("#translation_reference_helptext")[0], { 
        stylesheets: window.AA.editor_config.stylesheets,
        parserRules: window.AA.editor_config.parserRules, 
        style: true,  
        parser:               wysihtml5.dom.parse,
        composerClassName:    "wysihtml5-editor"
                                 
                } );
        editor.on('load', enforceInactiveStates);
   }
});
//}
