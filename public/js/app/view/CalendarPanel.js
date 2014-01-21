
Ext.define('AxAgenda.view.CalendarPanel', {
    extend: 'Extensible.calendar.CalendarPanel',
    alias: 'widget.axagenda.calendarpanel',
    id: 'app-calendar',

    requires: ['AxAgenda.view.EventDetails'],
    
    initComponent: function() {
	var me = this;

	// Ext.override(Extensible.calendar.view.AbstractCalendar, {
	me.callParent(arguments);

	this.remove('app-calendar-edit');
	this.add({
            xtype: 'axagenda.eventeditform',
            id: this.id+'-edit',
            calendarStore: this.calendarStore,
            recurrence: this.recurrence,
            startDay: this.startDay,
            listeners: {
                'eventadd':    { scope: this, fn: this.onEventAdd },
                'eventupdate': { scope: this, fn: this.onEventUpdate },
                'eventdelete': { scope: this, fn: this.onEventDelete },
                'eventcancel': { scope: this, fn: this.onEventCancel }
            }
	});
    },
    // requires: [
    // 	'Extensible.calendar.CalendarPanel', 'AxAgenda.store.Events', 'AxAgenda.store.Calendars'
    // ],

    activeItem: 1, // month view
    startDay: 0, // The 0-based index for the day on which the calendar week begins (0=Sunday)
    
    // Any generic view options that should be applied to all sub views:
    viewConfig: {
        //enableFx: false,
        ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
        viewStartHour: 1,
        // viewEndHour: 18,
        minEventDisplayMinutes: 5,
        showTime: true
    },

    dayViewCfg: {
        ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
        // viewStartHour: 6,
        // viewEndHour: 18,
        minEventDisplayMinutes: 1,
        showTime: true,
	hourHeight: 700
    },
    
    // View options specific to a certain view (if the same options exist in viewConfig
    // they will be overridden by the view-specific config):
    monthViewCfg: {
        showHeader: true,
        showWeekLinks: true,
        showWeekNumbers: true
    },

    weekViewCfg: {
	hourHeight: 700	
    },
    
    multiWeekViewCfg: {
	hourHeight: 100
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
    
});


    

