Ext.application({
    controllers: ["Main"],

    views: ["Main"],
    autoCreateViewport: false,
    name: 'Axagenda',
    launch: function() {

	/*Ext.create('Ext.container.Viewport', {
	  items: {
	  xtype: 'mainview'
	  }
	  });*/
	jasmine.getEnv().addReporter(new jasmine.TrivialReporter());
	jasmine.getEnv().execute();

    }
});

