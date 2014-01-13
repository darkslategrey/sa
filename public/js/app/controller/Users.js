


Ext.define('AxAgenda.controller.Users', { 
    extend: 'Ext.app.Controller',
    id: 'users-controller',

    stores: ['Users'],
    models: ['User'],
    views: [],

    init: function() {
	this.control({
	    'viewport > userlist': {
		itemdblclick: this.editUser
	    },
	    'useredit button[action=save]': {
		click: this.updateUser
	    }
	});
    },

    updateUser: function(button) {
	var win    = button.up('window'),
	    form   = win.down('form'),
	    record = form.getRecord(),
	    values = form.getValues();

	record.set(values);
	win.close();
    },
    
    editUser: function(grid, record) {
	var view = Ext.widget('useredit');
	view.down('form').loadRecord(record);
	console.log("Dbl click on" + record.get('name'));
    }
});
