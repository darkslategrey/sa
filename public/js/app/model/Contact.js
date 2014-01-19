


Ext.define('AxAgenda.model.Contact', {
    extend: 'Ext.data.Model',

    requires: [
	'Ext.data.association.BelongsTo',
	'Extensible.calendar.data.EventModel'
    ],
    
    fields: [
	{ name: 'civilite', type: 'string',
	  name: 'email', type: 'string',
	  name: 'firstname', type: 'string',
	  name: 'id', type: 'int',
	  name: 'name', type: 'string',
	  name: 'phones', type: 'string' }
    ],

    belongsTo: {
	model: 'Extensible.calendar.data.EventModel',
	name: 'event',
	foreignKey: 'contact_id'
    }
});
	  
