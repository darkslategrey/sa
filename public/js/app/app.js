/*!
 * Extensible 1.6.0-rc.1
 * Copyright(c) 2010-2013 Extensible, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
Ext.Loader.setConfig({
    enabled: true,
    disableCaching: false,
    paths: {
	"AxAgenda": "js/app"
	// "Extensible": "js/extensible/src",
	// "Ext": "js/extjs/src"
	// "Extensible.example": "./js"
    }
});

Ext.require([
    'Ext.container.Viewport',
    'Ext.layout.container.Border',
    'Ext.data.proxy.Rest',
    'Extensible.calendar.data.EventStore',
    'Extensible.calendar.data.CalendarModel',    
    'Extensible.calendar.gadget.CalendarListMenu',
    'Extensible.calendar.gadget.CalendarListPanel',    
    'AxAgenda.store.Calendars',
    'AxAgenda.view.CalendarPanel',
    'AxAgenda.view.UserListPanel'
]);

Ext.application({

    name: 'AxAgenda',
    appFolder: 'js/app',

    controllers: ['Calendars'],    

    launch: function() {

	Extensible.calendar.data.CalendarMappings = {
	    CalendarId:   {name:'CalendarId', mapping: 'id', type: 'int'},
	    Title:        {name:'Title', mapping: 'title', type: 'string'},
	    Description:  {name:'Description', mapping: 'desc', type: 'string'},
	    ColorId:      {name:'ColorId', mapping: 'color', type: 'int'},
	    IsHidden:     {name:'IsHidden', mapping: 'hidden', type: 'boolean'},
	};
	Extensible.calendar.data.CalendarModel.reconfigure();
	
	
	Extensible.calendar.data.EventMappings = {
            EventId:     {name: 'EventId', mapping:'id', type:'string'},
            CalendarId:  {name: 'CalendarId', mapping: 'cid', type: 'string'},
            Title:       {name: 'Title', mapping: 'title'},
            StartDate:   {name: 'Start', mapping: 'start', type: 'date', dateFormat: 'c'},
            EndDate:     {name: 'End', mapping: 'end', type: 'date', dateFormat: 'c'},
            Location:    {name: 'Location', mapping: 'location'},
            Notes:       {name: 'Notes', mapping: 'notes'},
            Url:         {name: 'Url', mapping: 'url'},
            IsAllDay:    {name: 'IsAllDay', mapping: 'all_day', type: 'boolean'},
            Reminder:    {name: 'Reminder', mapping: 'reminder'},
	    Owner:       {name: 'Owner',    mapping: 'owner'}
	};
	Extensible.calendar.data.EventModel.reconfigure();

	var reader = new Ext.data.reader.Json({
	    totalProperty: 'total',
	    successProperty: 'success',
	    root: 'calendars',
	    messageProperty: 'message',
	    // read the id property generically, regardless of the mapping:
	    idProperty: Extensible.calendar.data.CalendarMappings.CalendarId.mapping  || 'id',
	    // this is also a handy way to configure your reader's fields generically:
	    fields: Extensible.calendar.data.CalendarModel.prototype.fields.getRange()
	});
	
	var calendarStore = Ext.create('AxAgenda.store.Calendars', {
            autoLoad: true,
            proxy: {
		type: 'ajax',
		url: 'calendars',
		noCache: false,
		
		reader: reader
		// {
                //     type: 'json',
                //     root: 'calendars'
		// }
            }
	});

	// var jeUserStore = Ext.create('Ext.data.Store', {
        //     autoLoad: true,
        //     proxy: {
	// 	type: 'ajax',
	// 	pageParam: null,
	// 	startParam: null,
	// 	limitParam: null,
	// 	extraParams: { agenda: 'je'},
	// 	url: '/users',
	// 	noCache: false,
		
	// 	reader: {
        //             type: 'json',
        //             root: 'users'
	// 	}
        //     }
	    
	// });
	
	// var jdUserStore = Ext.create('Ext.data.Store', {
        //     autoLoad: true,
        //     proxy: {
	// 	type: 'ajax',
	// 	pageParam: null,
	// 	startParam: null,
	// 	limitParam: null,
	// 	extraParams: { agenda: 'jd'},
	// 	url: '/users',
	// 	noCache: false,
		
	// 	reader: {
        //             type: 'json',
        //             root: 'users'
	// 	}
        //     }
	// });
	
	var eventStore = Ext.create('Extensible.calendar.data.EventStore', {
            autoLoad: true,
            proxy: {
		type: 'rest',
		noCache: false,
		pageParam: null,
		startParam: null,
		limitParam: null,
		url: 'events',
		reader: {
                    type: 'json',
                    root: 'events'
		},
		writer: {
                    type: 'json',
                    nameProperty: 'mapping'
		}
            },

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
	
	// This is the actual calendar setup code -- pretty simple!
	var calendarPanel = Ext.create('AxAgenda.view.CalendarPanel', {
            id: 'app-calendar',
            region: 'center',
	    border: false,
            eventStore: eventStore,
            calendarStore: calendarStore,
	});

	var calendarList = Ext.create('Extensible.calendar.gadget.CalendarListPanel', {
	    layout: 'card',
	    autoHeight: 'false',
            store: calendarStore,
            border: false,
            width: 178,
	    height: 80,
	    collapsible: false
	});

	// users panels
	
	var jeUserListPanel = Ext.create('AxAgenda.view.UserListPanel', {
	    title: 'Utilisateurs Je',
	    agenda: 'je'
	    // store: jeUserStore
	});

	var jdUserListPanel = Ext.create('AxAgenda.view.UserListPanel', {
	    title: 'Utilisateurs Jd',
	    // store: jdUserStore,
	    agenda: 'jd'
	});

	Ext.create('Ext.container.Viewport', {
            layout: 'border',
            renderTo: 'calendar-ct',	    
	    items: [{
                id: 'app-header',
                region: 'north',
                height: 35,
                border: false,
                contentEl: 'app-header-content'
	    },{
                id: 'app-center',
                title: '...', // will be updated to the current view's date range
                region: 'center',
                layout: 'border',
                listeners: {
		    'afterrender': function(){
                        Ext.getCmp('app-center').header.addCls('app-center-header');
		    }
                },
                items: [{
		    id:'app-west',
		    region: 'west',
		    width: 179,
		    border: false,
		    items: [{
                        xtype: 'datepicker',
                        id: 'app-nav-picker',
                        cls: 'ext-cal-nav-picker',
                        startDay: 0,
                        listeners: {
			    'select': {
                                fn: function(dp, dt){
				    Ext.getCmp('app-calendar').setStartDate(dt);
                                },
                                scope: this
			    }
                        }
		    }, calendarList, jeUserListPanel, jdUserListPanel ]
                }, calendarPanel ]
	    }]
	});
    }
});

