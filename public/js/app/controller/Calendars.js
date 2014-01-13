


Ext.define('AxAgenda.controller.Calendars', {
    extend: 'Ext.app.Controller',
    id: 'calendars-controller',

    // stores: ['Calendars', 'Events'],
    // views:  ['CalendarPanel', 'CalendarListPanel', 'CalendarListMenu', 'MainPanel'],


    init: function() {
    	this.control({
    	    '#app-calendar': {
    		viewchange: this.updateTitle,
		eventclick: this.onEventClick,
		eventover: this.onEventOver,
		eventout: this.onEventOut,
		eventadd: this.onEventAdd,
		eventupdate: this.onEventUpdate,
		eventcancel: this.onEventCancel,
		dayclick: this.onDayClick,
		rangeselect: this.onRangeSelect,
		eventcopy: this.onEventCopy,
		eventmove: this.onEventMove,
		eventresize: this.onEventResize,
		eventdelete: this.onEventDelete,
		initdrag: this.onInitDrag
    	    },
	    '#app-nav-picker': {
		'select': this.onSelectDatePicker
	    }
    	});
    },

    onSelectDatePicker: function(dp, dt) {
    	Ext.getCmp('app-calendar').setStartDate(dt);	
    },
    
    onEventClick: function(vw, rec, el){
        this.clearMsg();
    },
    
    onEventOver: function(vw, rec, el){
        console.log('Entered evt rec='+rec.data[Extensible.calendar.data.EventMappings.Title.name]+', view='+ vw.id +', el='+el.id);
    },
    
    onEventOut: function(vw, rec, el){
        console.log('Leaving evt rec='+rec.data[Extensible.calendar.data.EventMappings.Title.name]+', view='+ vw.id +', el='+el.id);
    },
    
    onEventAdd: function(cp, rec) {
        this.showMsg('Event '+ rec.data[Extensible.calendar.data.EventMappings.Title.name] +' was added');	
    },
    
    onEventUpdate: function(cp, rec) {
        this.showMsg('Event '+ rec.data[Extensible.calendar.data.EventMappings.Title.name] +' was updated');	
    },
    onEventCancel: function(cp, rec) {
	console.log('event cancel');
    },
    onDayClick: function(vw, dt, ad, el) {
        this.clearMsg();	
    },
    
    onRangeSelect: function(vw, dates, onComplete){
        this.clearMsg();
    },
    
    onEventMove: function(vw, rec) {
	this.onEventCopyOrMove(rec, 'move');
    },
    
    onEventCopy: function(vw, rec) {
	this.onEventCopyOrCopy(rec, 'copy');
    },

    
    onEventResize: function(vw, rec) {
	rec.commit();
        this.showMsg('Event '+ rec.data[Extensible.calendar.data.EventMappings.Title.name] +' was updated');	
    },
    onEventDelete: function(win, rec) {
	this.eventsStore.remove(rec);
        this.showMsg('Event '+ rec.data[Extensible.calendar.data.EventMappings.Title.name] +' was deleted');
    },
    
    onInitDrag: function(vw) {
	console.log('event start drag');
    },
    
    // The CalendarPanel itself supports the standard Panel title config, but that title
    // only spans the calendar views.  For a title that spans the entire width of the app
    // we added a title to the layout's outer center region that is app-specific. This code
    // updates that outer title based on the currently-selected view range anytime the view changes.
    // updateTitle: function(startDt, endDt){
    updateTitle: function(panel, view, dateInfos){
	if(!dateInfos) {
	    return;
	}
	var p       = Ext.getCmp('app-center'),
	    startDt = dateInfos.viewStart,
	    endDt   = dateInfos.viewEnd,
            fmt     = Ext.Date.format;
        
        if(Ext.Date.clearTime(startDt).getTime() === Ext.Date.clearTime(endDt).getTime()){
            p.setTitle(fmt(startDt, 'F j, Y'));
        }
        else if(startDt.getFullYear() === endDt.getFullYear()){
            if(startDt.getMonth() === endDt.getMonth()){
                p.setTitle(fmt(startDt, 'F j') + ' - ' + fmt(endDt, 'j, Y'));
            }
            else{
                p.setTitle(fmt(startDt, 'F j') + ' - ' + fmt(endDt, 'F j, Y'));
            }
        }
        else{
            p.setTitle(fmt(startDt, 'F j, Y') + ' - ' + fmt(endDt, 'F j, Y'));
        }
    },
    

    // Handle event moves or copies generically
    onEventCopyOrMove: function(rec, mode) {
        var mappings = Extensible.calendar.data.EventMappings,
            time = rec.data[mappings.IsAllDay.name] ? '' : ' \\a\\t g:i a',
            action = mode === 'copy' ? 'copied' : 'moved';
        
        rec.commit();
        
        this.showMsg('Event '+ rec.data[mappings.Title.name] +' was ' + action + ' to '+
		     Ext.Date.format(rec.data[mappings.StartDate.name], ('F jS'+time)));
    },
    
    // This is an application-specific way to communicate CalendarPanel event messages back to the user.
    // This could be replaced with a function to do "toast" style messages, growl messages, etc. This will
    // vary based on application requirements, which is why it's not baked into the CalendarPanel.
    showMsg: function(msg){
        Ext.fly('app-msg').update(msg).removeCls('x-hidden');
    },
    
    clearMsg: function(){
        Ext.fly('app-msg').update('').addCls('x-hidden');
    }
});
