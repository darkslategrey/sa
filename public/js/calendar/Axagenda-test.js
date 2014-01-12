

Ext.Loader.setConfig ({
    enabled: true,
    paths: {
	"Axagenda": "js/calendar/axagenda"
    }
});

Ext.require('Ext.app.Application');
Ext.require('Axagenda.data.UserStore');

// Loading different components like controller, model, view..
Ext.onReady(function() {
    Ext.create('Ext.app.Application',{
	controllers: [ ],
	models:      [ ],
	stores:      [ 'Axagenda.data.UserStore', 'userStore', 'usersStore' ],
	views:       [ ],
	
	autoCreateViewport: false,    
	
	name: 'AxAgenda',

	launch: function () {
	    var jasmineEnv = jasmine.getEnv ();
	    jasmineEnv.updateInterval = 1000;
	    var htmlReporter = new jasmine.HtmlReporter ();
	    jasmineEnv.addReporter (htmlReporter);
	    jasmineEnv.execute ();
	}
    });
});


var myApp = AxAgenda.getApplication();






// var Application = null;

// Ext.onReady(function() {
//     Application = Ext.create('Ext.app.Application', {
// 	name: 'AM',

// 	controllers: [
// 	    'Users'
// 	],

// 	launch: function() {
// 	    //include the tests in the test.html head
// 	    jasmine.getEnv().addReporter(new jasmine.TrivialReporter());
// 	    jasmine.getEnv().execute();
// 	}
//     });
// });
