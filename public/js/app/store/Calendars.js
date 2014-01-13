


Ext.define('AxAgenda.store.Calendars', {
    extend: 'Ext.data.Store',
    model: 'AxAgenda.model.Calendar',

    requires: [
        'Ext.data.reader.Json',
        'Ext.data.writer.Json',
        'AxAgenda.model.Calendar',
        'Extensible.calendar.data.CalendarMappings'
    ],
    
    autoLoad: true,


    proxy: {
	type: 'rest',
	url: '/calendars',
        reader: {
            type: 'json',
            root: 'calendars'
        },
        writer: {
            type: 'json'
        }
    }
});
