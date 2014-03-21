App.InstallerStep1View1 = App.InstallerStepView.extend()

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

App.FileUploader1 = Ember.View.extend
    templateName: 'common/file_upload'
    didInsertElement: ->
        upload = $('<button/>').addClass('btn btn-primary').prop('disabled', true).text('processing...').on 'click', ->
            $this = $(this)
            data = $this.data()
            $this.off('click')
                .text('Abort')
                .on 'click', ->
                    $this.remove()
                    data.abort()
            data.submit().always ->
                $this.remove()

        $('#fileupload').fileupload
            url: '/octopus/api/v1/boot/upload'
            dataType: 'json'
            autoUpload: false
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
            maxFileSize: 5000000
            disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent)
            previewMaxWidth: 100
            previewMaxHeight: 100
            previewCrop: true
        .on 'fileuploadadd', (e, data) ->
            console.log 'fileuploadadd'
            data.context = $('<div/>').appendTo '#files'
            $.each data.files, (idx, file) ->
                node = $('<p/>').append($('<span/>').text(file.name))
                if not idx
                    node.append('<br>')
                        .append(upload.clone(true).data(data))
                node.appendTo data.context
            console.log data.context
            console.log data.context.find('button')
            btn = $('#uploadsubmit')
            btn.off 'click'
                .on 'click', ->
                    data.submit()
        .on 'fileuploadprocessalways', (e, data) ->
            console.log 'fileuploadprocessalways'
            console.log data
            console.log data.context
            index = data.index
            file = data.files[index]
            node = $(data.context.children()[index])
            console.log index
            console.log data.files.length
            if file.preview
                node.prepend('<br>')
                    .prepend(file.preview)
            if file.error
                node.append('<br>')
                    .append($('<span class="text-danger"/>').text(file.error))
            console.log if index + 1 is data.files.length then 'yes' else 'no'
            if index + 1 is data.files.length
                console.log 'yesyes'
                console.log data.context.find('button')
                console.log data.context
                data.context.find('button')
                    .text('Upload')
                    .prop('disabled', !!data.files.error)
        .on 'fileuploadprogressall', (e, data) ->
            console.log 'fileuploadprogressall'
            progress = parseInt(data.loaded / data.total * 100, 10)
            $('#progress .progress-bar').css 'width', progress + '%'
        .on 'fileuploaddone', (e, data) ->
            console.log 'fileuploaddone'
            console.log data.result
            console.log data.result.files
            $.each data.result.files, (idx, file) ->
                console.log '---------------', $(data.context.children()[idx]).find('button').text('Abort')
                if file.url
                    link = $('<a>')
                            .attr 'target', '_blank'
                            .prop 'href', file.url
                    $(data.context.children()[idx]).wrap link
                else if file.error
                    error = $('<span class="text-danger"/>').text file.error
                    $(data.context.children()[idx])
                        .append '<br>'
                        .append error
        .on 'fileuploadfail', (e, data) ->
            $.each data.files, (idx, file) ->
                error = $('<span class="text-danger"/>').text 'File upload failed.'
                $(data.context.children()[idx])
                    .append '<br>'
                    .append error
        .prop 'disabled', not $.support.fileInput
        .parent().addClass(if $.support.fileInput then undefined else 'disabled')