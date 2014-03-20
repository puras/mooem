App.InstallerStep1View = App.InstallerStepView.extend()

App.TemplateFileUploader = Ember.View.extend
    template: Ember.Handlebars.compile('<input type="file" />')
    change: (e) ->
        console.log 'fileuploader'
        console.log e.target
        self = @
        if e.target.files && e.target.files.length == 1
            file = e.target.files[0]
            reader = new FileReader()
            reader.onload = ((theFile) ->
                (e) ->
                    console.log e.target.result
                    $('#template').html e.target.result
            )(file)
            reader.readAsText(file)