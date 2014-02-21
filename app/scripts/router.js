App.Router.map(function() {
    this.resource('resources');
    this.resource('templates', function() {
        this.route('import');
        this.route('export');
        this.route('template', { path: ':template_id' });
    });
});