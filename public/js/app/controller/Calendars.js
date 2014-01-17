


Ext.define('AxAgenda.controller.Calendars', {
    extend: 'Ext.app.Controller',
    id: 'calendars-controller',


    requires: [ 'AxAgenda.model.UsersStates' ],
    // stores: ['Calendars', 'Events'],
    // views:  ['CalendarPanel', 'CalendarListPanel', 'CalendarListMenu', 'MainPanel'],
    views: ['UserListPanel'],

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
	    // '#je-button': {
	    // 	toggle: this.onUserListClick
	    // },
	    // '#jd-button': {
	    // 	toggle: this.onUserListClick
	    // },

	    '#event-window': {
		
	    },
	    
	    '#jd-users-checkboxgroup': {
		change: this.onUserCheckboxChange
	    },
	    '#je-users-checkboxgroup': {
		change: this.onUserCheckboxChange
	    },
	    '#app-nav-picker': {
		'select': this.onSelectDatePicker
	    }
    	});
    },

    onUserCheckboxChange: function(elt, newValue, oldValue, eOpts) {
	// console.log("user checked ov " + oldValue + " nv " + newValue);
	var agenda     = elt.id.split('-')[0];
	var visible    = newValue.user;
	var allUsers   = AxAgenda.model.UsersStates[agenda].allUsers;
	var notVisible;
	if(typeof newValue.user ==  "number") {
	    notVisible = allUsers.filter(function(elt, index, array) {
		return(visible != elt);
	    });
	    visible = [ newValue.user ];	    
	} else if(newValue.user == undefined) {
	    notVisible = allUsers;
	    visible    = [];
	} else { // an object
	    notVisible = allUsers.filter(function(elt, index, array) {	    
		return(visible.indexOf(elt) == -1);
	    });
	}
	AxAgenda.model.UsersStates[agenda].visible = visible;
	AxAgenda.model.UsersStates[agenda].notVisible = notVisible;
	Ext.getCmp('app-calendar').getActiveView().refresh(false);	
    },
    
    onUserListClick: function(elt, pressed, opts) {
	console.log("user list clicked");

	var listPanel  = elt.findParentByType('panel');
	if(pressed) {
	    AxAgenda.model.UsersStates[listPanel.agenda].visible = AxAgenda.model.UsersStates[listPanel.agenda].allUsers;
	    AxAgenda.model.UsersStates[listPanel.agenda].notVisible = [];
	} else {
	    AxAgenda.model.UsersStates[listPanel.agenda].notVisible = AxAgenda.model.UsersStates[listPanel.agenda].allUsers;
	    AxAgenda.model.UsersStates[listPanel.agenda].visible = [];	    
	}

	Ext.getCmp('app-calendar').getActiveView().refresh(false);
	

        // var rec = this.store.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, 1);
        // if(rec.data[Extensible.calendar.data.CalendarMappings.IsHidden.name] !== true) {
        //     this.toggleCalendar(id, commit);

	// var eventStore = listPanel.eventStore;
	// var calendarStore = listPanel.calendarStore;
	// calendar = calendarStore.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, 2);
	
	    
	// events = eventStore.data.getRange();
	// console.log("events size " + events.length);

	// maj du store
        // store.commitChanges() just loops over each modified record and calls rec.commit(),
        // which in turns fires an update event that would cause a full refresh for each record.
        // To avoid this we simply set a flag and make sure we only refresh once per commit set.
        // this.skipRefresh = true;
        // this.store.sync();
        // delete this.skipRefresh;
        // this.refresh();
	
	// var calendarStore = this.store.findRecord(Exten;
	// var agenda = calendarPanel.get
	// if(pressed) {
	//     calendar.eventStore.get
	// } else {
	    
	// }
    },
    onUserJdListClick: function(elt, pressed, opts) {
	console.log("jd clicked");

        // var rec = this.store.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, 2);
        // if(rec.data[Extensible.calendar.data.CalendarMappings.IsHidden.name] !== true) {
        //     this.toggleCalendar(id, commit);
	
	var listPanel  = elt.findParentByType('panel');
	// var eventStore = listPanel.eventStore;
	var calendarStore = listPanel.calendarStore;

	// on appel ca sur les calendars pour reafficher les events
        this.prepareData();
        this.renderTemplate();
        this.renderItems();

	// redefinir le isEventVisible ?

	// ici on filtre les events du store d'un calendar (prepareData)
        var evtsInView = this.store.queryBy(function(rec) {
            return this.isEventVisible(rec.data);
        }, this);

	// event.owner est l'id du user

	// events = eventStore.data.getRange();
	calendarStore.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, 2);
	console.log("events size " + events.length);
	
    },
    
    onSelectDatePicker: function(dp, dt) {
    	Ext.getCmp('app-calendar').setStartDate(dt);	
    },
    
    onEventClick: function(vw, rec, el){
        this.clearMsg();
    },
    
    onEventOver: function(vw, rec, el){
        // console.log('Entered evt rec='+rec.data[Extensible.calendar.data.EventMappings.Title.name]+', view='+ vw.id +', el='+el.id);
    },
    
    onEventOut: function(vw, rec, el){
        // console.log('Leaving evt rec='+rec.data[Extensible.calendar.data.EventMappings.Title.name]+', view='+ vw.id +', el='+el.id);
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
