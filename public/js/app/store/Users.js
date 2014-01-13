




Ext.define('AxAgenda.store.Users', {
    extend: 'Ext.data.Store',
    model: 'AxAgenda.model.User',
    // autoLoad: true,

    
    proxy: {
	type: 'rest',
	 url: '/users'
	// reader: {
	//     type: 'json',
	//     root: 'events'
	// },
	// write: {
	//     type: 'json'
	// }
    }
    
});

