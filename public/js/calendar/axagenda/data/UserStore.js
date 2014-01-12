


Ext.define('Axagenda.data.UserStore', {
    extend: 'Ext.data.Store',
    model: 'Axagenda.data.UserModel',

    storeId: 'userStore',
    
    requires: [
        'Ext.data.proxy.Rest',
	'Axagenda.data.UserModel'
    ],

    proxy: {
        type: 'rest',
        // reader: {
        //     root: 'users',
        // },
	url: '/users'
    }
});
