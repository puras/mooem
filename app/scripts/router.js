App.Router.map(function() {
    this.resource('resources');
    this.resource('templates', function() {
        this.route('import');
        this.route('export');
        this.route('template', { path: ':template_id' });
    });
    this.route('login');
    this.resource('installer', function() {
        this.route('step0');
        this.route('step1');
        this.route('step2');
        this.route('step3');
        this.route('step4');
        this.route('step5');
        this.route('step6');
    });
});