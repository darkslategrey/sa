Ext.define('AxAgenda.store.Events', {
    extend: 'Extensible.calendar.data.EventStore',
    model: 'AxAgenda.model.Event',    
    autoLoad: true,
    proxy: {
	type: 'rest',
	noCache: true,
	pageParam: null,
	startParam: null,
	limitParam: null,

	url: '/events',
	reader: {
	    type: 'json',
	    root: 'data'
	},
	writer: {
	    type: 'json',
	    nameProperty: 'mapping'
	}
    },
    // It's easy to provide generic CRUD messaging without having to handle events on every individual view.
    // Note that while the store provides individual add, update and remove events, those fire BEFORE the
    // remote transaction returns from the server -- they only signify that records were added to the store,
    // NOT that your changes were actually persisted correctly in the back end. The 'write' event is the best
    // option for generically messaging after CRUD persistence has succeeded.
    listeners: {
	'write': function(store, operation) {
	    var title = Ext.value(operation.records[0].data[Extensible.calendar.data.EventMappings.Title.name], '(No title)');
	    switch(operation.action){
	    case 'create':
		Extensible.example.msg('Add', 'Added "' + title + '"');
		break;
	    case 'update':
		Extensible.example.msg('Update', 'Updated "' + title + '"');
		break;
	    case 'destroy':
		Extensible.example.msg('Delete', 'Deleted "' + title + '"');
		break;
	    }
	}
    }
});
