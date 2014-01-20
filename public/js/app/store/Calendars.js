


Ext.define('AxAgenda.store.Calendars', {
    extend: 'Ext.data.Store',
    model: 'Extensible.calendar.data.CalendarModel',    

    requires: [
        'Ext.data.reader.Json',
        'Ext.data.writer.Json',
	'Extensible.calendar.data.CalendarModel',	
        'Extensible.calendar.data.CalendarMappings'
    ],

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
