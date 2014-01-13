

Ext.define('AxAgenda.view.MainPanel', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.axagenda.mainpanel',

    requires: [
	'Ext.layout.container.Border',
	'AxAgenda.view.CalendarListPanel',
	'AxAgenda.view.CalendarPanel',
	// 'AxAgenda.store.Calendars',
	// 'AxAgenda.store.Events',
	'AxAgenda.store.MemoryCalendarStore',
	'AxAgenda.store.MemoryEventStore',
        'AxAgenda.data.Events',
        'AxAgenda.data.Calendars'
	
    ],

    // eventsStore:    Ext.create('AxAgenda.store.Events', {
    // }),
    constructor: function() {
	this.eventsStore = Ext.create('AxAgenda.store.MemoryEventStore', {
	    data: Ext.create("AxAgenda.data.Events")
	});

	this.calendarsStore =  Ext.create('AxAgenda.store.MemoryCalendarStore', {
	    data: Ext.create("AxAgenda.data.Calendars")
	});
	this.callParent(arguments);
	
    },
    
    // eventsStore:    Ext.create('Ext.data.Store'),
    // calendarsStore: Ext.create('Ext.data.Store'),
    
    
    // This is the app UI layout code.  All of the calendar views are subcomponents of
    // CalendarPanel, but the app title bar and sidebar/navigation calendar are separate
    // pieces that are composed in app-specific layout code since they could be omitted
    // or placed elsewhere within the application.

    // layout: 'border',
    // renderTo: 'calendar-ct',

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
            },{
                xtype: 'axagenda.calendarlist',
                store: this.calendarStore,
                border: false,
                width: 178
            }]
        },{
            xtype: 'axagenda.calendarpanel',
            eventStore: this.eventStore,
            calendarStore: this.calendarStore,
            border: false,
            id:'app-calendar',
            region: 'center',
            activeItem: 3, // month view
            startDay: 0,
            
            // Any generic view options that should be applied to all sub views:
            viewConfig: {
                //enableFx: false,
                //ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
                //viewStartHour: 6,
                //viewEndHour: 18,
                //minEventDisplayMinutes: 15
                showTime: false
            },
            
            // View options specific to a certain view (if the same options exist in viewConfig
            // they will be overridden by the view-specific config):
            monthViewCfg: {
                showHeader: true,
                showWeekLinks: true,
                showWeekNumbers: true
            },
            
            multiWeekViewCfg: {
                //weekCount: 3
            },
            
            // Some optional CalendarPanel configs to experiment with:
            //readOnly: true,
            //showDayView: false,
            //showMultiDayView: true,
            //showWeekView: false,
            //showMultiWeekView: false,
            //showMonthView: false,
            //showNavBar: false,
            //showTodayText: false,
            //showTime: false,
            //editModal: true,
            //enableEditDetails: false,
            //title: 'My Calendar', // the header of the calendar, could be a subtitle for the app
            
        }]
    }
	   ]
});
	//     items: [
	//     	{
	//             id: 'app-header',
	//             region: 'north',
	//             height: 35,
	//             border: false,
	//             contentEl: 'app-header-content'
	//     	},{
	//             id: 'app-center',
	//             title: '...', // will be updated to the current view's date range
	//             region: 'center',
	//             layout: 'border',
	//             listeners: {
	//     		'afterrender': function(){
	//                     Ext.getCmp('app-center').header.addCls('app-center-header');
	//     		}
	// 	    },
	//             items: [{
	//     	    	id:'app-west',
	//     	    	region: 'west',
	//     	    	width: 179,
	//     	    	border: false,
	//     	    	items: [{
	//                     xtype: 'datepicker',
	//                     id: 'app-nav-picker',
	//                     cls: 'ext-cal-nav-picker',
	//                     startDay: 0, // startDay,
	//     	    	},{
	//                     xtype: 'axagenda.calendarlist',
	//     	    	    store: this.calendarsStore,
	//                     border: false,
	//                     width: 178
	//     	    	}]
	//             },{
	//     	    	xtype: 'axagenda.calendarpanel',
	//     	    	eventStore: this.eventsStore,
	//     	    	calendarStore: this.calendarsStore,
	//                 border: false,
	//                 id:'app-calendar',
	//                 region: 'center',
	//                 activeItem: 3, // month view
	//                 startDay: 0
	//             }]
	
	// 	}]
	// });


	

