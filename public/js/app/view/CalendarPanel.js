
Ext.define('AxAgenda.view.CalendarPanel', {
    extend: 'Extensible.calendar.CalendarPanel',
    alias: 'widget.axagenda.calendarpanel',
    id: 'app-calendar',

    // requires: [
    // 	'Extensible.calendar.CalendarPanel', 'AxAgenda.store.Events', 'AxAgenda.store.Calendars'
    // ],
    
    activeItem: 3, // month view
    startDay: 0, // The 0-based index for the day on which the calendar week begins (0=Sunday)
    
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
    
});


    

