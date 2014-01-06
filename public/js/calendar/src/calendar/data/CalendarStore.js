


Ext.define('Axagenda.calendar.data.CalendarStore', {
    extend: 'Ext.data.Store',
    model: 'Extensible.calendar.data.CalendarModel',
    
    require: [
	'Ext.data.proxy.Rest',
	'Ext.data.reader.Json',
	'Ext.data.writer.Json',
        'Extensible.calendar.data.CalendarModel',
        'Extensible.calendar.data.CalendarMappings'
    ],

    proxy: {
        type: 'rest',
        noCache: false,
	
	url: '/calendars',

        reader: {
            type: 'json',
            root: 'calendars'
        },

        writer: {
            type: 'json'
        }
    },

    autoLoad: true,

    initComponent: function() {
        this.sorters = this.sorters || [{
            property: Extensible.calendar.data.CalendarMappings.Title.name,
            direction: 'ASC'
        }];
        
        this.idProperty = this.idProperty || Extensible.calendar.data.CalendarMappings.CalendarId.name || 'id';
        
        this.fields = Extensible.calendar.data.CalendarModel.prototype.fields.getRange();
        
        this.callParent(arguments);
    }
});
