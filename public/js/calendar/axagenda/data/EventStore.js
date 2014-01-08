


Ext.define('Axagenda.data.EventStore', {
    extend: 'Extensible.calendar.data.EventStore',

    proxy: {
        type: 'rest',
        reader: {
	    type: 'json',
            root: 'events'
        },
        writer: {
            type: 'json',
            nameProperty: 'mapping'
        },
	
	url: '/events'
    }
});
