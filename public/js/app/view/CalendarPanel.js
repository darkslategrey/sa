
Ext.define('AxAgenda.view.CalendarPanel', {
    extend: 'Extensible.calendar.CalendarPanel',
    alias: 'widget.axagenda.calendarpanel',
    id: 'app-calendar',

    initComponent: function() {
	var me = this;

	me.getEventEditor: function() {
	},

	// Ext.override(Extensible.calendar.view.AbstractCalendar, {
	me.callParent(arguments);
    },
    // requires: [
    // 	'Extensible.calendar.CalendarPanel', 'AxAgenda.store.Events', 'AxAgenda.store.Calendars'
    // ],
    
    activeItem: 3, // month view

    startDay: 0, // The 0-based index for the day on which the calendar week begins (0=Sunday)

    recurrence: true,
    
    // Any generic view options that should be applied to all sub views:
    viewConfig: {
        enableFx: true,
        ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
        viewStartHour: 8,
        viewEndHour: 22,
        minEventDisplayMinutes: 30,
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
    showMultiDayView: true,
    //showWeekView: false,
    //showMultiWeekView: false,
    //showMonthView: false,
    showNavBar: true,
    editWin =  Ext.WindowMgr.get('axagenda-cal-editwin'),
    // showTodayText: false,
    //showTime: false,
    editModal: true,
    //enableEditDetails: false,
    //title: 'My Calendar', // the header of the calendar, could be a subtitle for the app

    static: {

	
	msg: function(title, format){
            if(!this.msgCt){
		this.msgCt = Ext.core.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
            }
            this.msgCt.alignTo(document, 't-t');
            var s = Ext.String.format.apply(String, Array.prototype.slice.call(arguments, 1));
            var m = Ext.core.DomHelper.append(this.msgCt, {html:'<div class="msg"><h3>' + title + '</h3><p>' + s + '</p></div>'}, true);
            
            m.slideIn('t').pause(3000).ghost('t', {remove:true});
	}
    }
});


    

