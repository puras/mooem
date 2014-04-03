App.InstallerStep1View = App.InstallerStepView.extend
    didInsertElement: ->
        # @get('controller').load_template()

App.RemoveTemplateView = Ember.View.extend
    templateName: 'installer/step3_remove_template'
    tagName: 'span'
    temp: null
    click: (event) ->
        if confirm('确认删除?')
            console.log @get 'temp'
            @get('controller').send 'remove_template', @get 'temp'

App.FileUploader = Ember.View.extend
    templateName: 'common/file_upload'
    didInsertElement: ->
        self = @
        # 为每个资源增加一个上传按钮
        # 设置为隐藏，由“开始上传”按钮统一触发
        upload_btn = $('<button/>').addClass 'btn btn-primary' 
                                    .prop 'disabled', true
                                    .text 'processing...'
                                    .on 'click', ->
                                        $this = $(this)
                                        data = $this.data()
                                        $this.off 'click'
                                            .text 'Abort'
                                            .on 'click', ->
                                                $this.remove()
                                                data.abort()
                                        data.submit().always ->
                                            $this.remove()
                                    .hide()
        # 为有错误的资源，增加一个删除按钮
        remove_btn = $('<button/>').addClass 'btn btn-primary'
                                    .text 'remove'
                                    .on 'click', ->
                                        $this = $(this)
                                        data = $this.data()
                                        console.log data
                                        $this.parent().parent().remove()

        # “开始上传”按钮，模拟每个文件的上传操作
        start_all = $('.start')
        start_all.off 'click'
            .on 'click', ->
                # $('#progress').css 'display', 'block'
                $('#progress .progress-bar').css 'width', '0%'
                files = $('#files')
                bts = files.find 'button'
                bts.click()
        $('.cancel').off 'click'
            .on 'click', ->
                $('#progress .progress-bar').css 'width', '0%'
                $('#files').empty()
        $('#fileupload').fileupload
            url: '/octopus/api/v1/templates/upload'
            dataType: 'json'
            autoUpload: false
            # acceptFileTypes: /(\.|\/)(xml)$/i
            maxFileSize: 100000000
        .on 'fileuploadadd', (e, data) ->
            console.log 'fileuploadadd'
            console.log data
            data.context = $('<div/>').appendTo '#files'
            $.each data.files, (idx, file) ->
                node = $('<p/>').append($('<span/>').text('文件名: ' + file.name + ', 文件大小: ' + Math.round(file.size / 1024, 10) + ' K'))
                if not idx
                    node.append '<br>'
                        .append upload_btn.clone(true).data(data)
                node.appendTo data.context
        .on 'fileuploadprocessalways', (e, data) ->
            idx = data.index
            file = data.files[idx]
            node = $(data.context.children()[idx])
            if file.error
                node.find('button').remove()
                node.append '<br>'
                    .append $('<span class="text-danger"/>').text file.error
                    .append '<br>'
                    .append remove_btn.clone(true).data(data)
            else if idx + 1 is data.files.length
                data.context.find('button')
                    .text 'Upload'
                    .prop 'disabled', !!data.files.error
        .on 'fileuploadprogressall', (e, data) ->
            progress = parseInt(data.loaded / data.total * 100, 10)
            $('#progress .progress-bar').css 'width', progress + '%'
        .on 'fileuploaddone', (e, data) ->
            if data.result.files and data.result.files.length == 0 and data.result.error
                error = $('<span class="text-danger"/>').text 'File upload Failed.' + data.result.error
                $(data.context.children()[0])
                    .append '<br>'
                    .append error
            else
                $.each data.result.files, (idx, file) ->
                    console.log file
                    info = $('<span class="text-success"/>').text 'File upload Success.'
                    $(data.context.children()[idx])
                        .append '<br>'
                        .append info
                self.get('controller').send 'load_templates'
        .on 'fileuploadfail', (e, data) ->
            $.each data.files, (idx, file) ->
                error = $('<span class="text-danger"/>').text 'File upload failed.'
                $(data.context.children()[idx])
                    .append '<br>'
                    .append error
        .prop 'disabled', not $.support.fileInput
        .parent().addClass(if $.support.fileInput then undefined else 'disabled')