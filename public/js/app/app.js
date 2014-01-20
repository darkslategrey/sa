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
	"AxAgenda": "/js/app",	// SUBSTITUTE FOR DEPLOY
	"Extensible": "/js/extensible/src", // SUBSTITUTE FOR DEPLOY
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
    'Extensible.calendar.form.EventWindow',
    'AxAgenda.store.Calendars',
    'AxAgenda.view.CalendarPanel',
    'AxAgenda.view.UserListPanel',
    'AxAgenda.view.EventWindow',
    'AxAgenda.model.UsersStates'
    // 'AxAgenda.model.Contact',    
    // 'Extensible.calendar.view.AbstractCalendar'
]);

Ext.application({

    name: 'AxAgenda',
    appFolder: '/js/app',  // SUBSTITUTE FOR DEPLOY  

    controllers: ['Calendars'],    

    launch: function() {


	
	// Extensible.calendar.form.EventWindow.prototype.initComponent = Ext.Function.createSequence(Extensible.calendar.form.EventWindow.prototype.initComponent, function() {
	//     this.add({
	// 	xtype: 'textfield',
	// 	fieldLabel: 'Tel'
	//     }, {
	// 	xtype: 'textfield',
	// 	fieldLabel: 'Email'
	//     })
	// });

		
		
	// Ext.apply('Extensible.calendar.data.EventModel', {
	//     getContactEmail: function() {
	// 	this.data['contact']['email'];
	//     },
	//     getContactTel: function() {
	// 	this.data['contact']['tel'];
	//     }
	// });

	// Ext.apply('Extensible.calendar.form.EventWindow', {

	    
	// });

	// Ext.override(Extensible.calendar.data.EventModel, {
	//     associations: [{
	// 	type:'hasOne',
	// 	model:'AxAgenda.model.Contact',
	// 	autoload: true
	//     }]
	// });

	// Ext.override(Extensible.calendar.form.EventWindow, {

	//     initComponent: function() {
	// 	this.addEvents({
	// 	    eventadd: true,
	// 	    eventupdate: true,
	// 	    eventcancel: true,
	// 	    editdetails: true
	// 	});
	// 	this.fbar = ['->', {
	// 	    xtype: 'tbtext',
	// 	    itemId: this.id + '-details-btn',
	// 	    text: '<a href="#" class="' + this.editDetailsLinkClass + '">' + this.detailsLinkText + '</a>'
	// 	},{
        //             text: this.saveButtonText,
        //             itemId: this.id + '-save-btn',
        //             disabled: false,
        //             handler: this.onSave,
        //             scope: this
	// 	},{
        //             text: this.cancelButtonText,
        //             itemId: this.id + '-cancel-btn',
        //             disabled: false,
        //             handler: this.onCancel,
        //             scope: this
	// 	}];
	// 	this.callParent(arguments);
	//     },
	    
	//     getFormItemConfigs: function() {
	// 	var items = [{
	// 	    xtype: 'textfield',
	// 	    itemId: this.id + '-title',
	// 	    name: Extensible.calendar.data.EventMappings.Title.name,
	// 	    fieldLabel: this.titleLabelText,
	// 	    anchor: '100%'
	// 	},{
	// 	    xtype: 'extensible.daterangefield',
	// 	    itemId: this.id + '-dates',
	// 	    name: 'dates',
	// 	    anchor: '95%',
	// 	    singleLine: true,
	// 	    startDay: this.startDay,
	// 	    fieldLabel: this.datesLabelText
	// 	},{
	// 	    xtype: 'textfield',
	// 	    itemId: this.id + '-tel',
	// 	    name: 'ContactPhone',
	// 	    fieldLabel: 'Tel',
	// 	    anchor: '100%'
	// 	},{
	// 	    xtype: 'textfield',
	// 	    itemId: this.id + '-telmobile',
	// 	    name: 'ContactPhoneMobile',
	// 	    fieldLabel: 'Tel mobile',
	// 	    anchor: '100%'
	// 	},{
	// 	    xtype: 'textfield',
	// 	    itemId: this.id + '-telperso',
	// 	    name: 'ContactPhonePerso',
	// 	    fieldLabel: 'Tel perso',
	// 	    anchor: '100%'
	// 	},{
	// 	    xtype: 'textfield',
	// 	    itemId: this.id + '-mail',
	// 	    name: 'ContactMail',
	// 	    fieldLabel:'Email',
	// 	    anchor: '100%'
	// 	}];
		
	// 	if(this.calendarStore) {
	// 	    items.push({
	// 		xtype: 'extensible.calendarcombo',
	// 		itemId: this.id + '-calendar',
	// 		name: Extensible.calendar.data.EventMappings.CalendarId.name,
	// 		anchor: '100%',
	// 		fieldLabel: 'Agenda',
	// 		store: this.calendarStore
	// 	    });
	// 	}
		
	// 	return items;
	//     }
	//  });


	Ext.override(Extensible.calendar.view.AbstractCalendar, {

	    
	    // private
	    getEventEditor: function() {
		// only create one instance of the edit window, even if there are multiple CalendarPanels
		this.editWin = this.editWin || Ext.WindowMgr.get('ext-cal-editwin');

		if (!this.editWin) {
		    this.editWin = Ext.create('AxAgenda.view.EventWindow', {
			id: 'ext-cal-editwin',
			calendarStore: this.calendarStore,
			modal: this.editModal,
			enableEditDetails: this.enableEditDetails,
			startDay: this.startDay,

			listeners: {
			    'eventadd': {
				fn: function(win, rec, animTarget, options) {
				    //win.hide(animTarget);
				    win.currentView.onEventEditorAdd(null, rec, options);
				},
				scope: this
			    },
			    'eventupdate': {
				fn: function(win, rec, animTarget, options) {
				    //win.hide(animTarget);
				    win.currentView.onEventEditorUpdate(null, rec, options);
				},
				scope: this
			    },
			    'eventdelete': {
				fn: function(win, rec, animTarget, options) {
				    //win.hide(animTarget);
				    win.currentView.onEventEditorDelete(null, rec, options);
				},
				scope: this
			    },
			    'editdetails': {
				fn: function(win, rec, animTarget, view) {
				    // explicitly do not animate the hide when switching to detail
				    // view as it looks weird visually
				    win.animateTarget = null;
				    win.hide();
				    win.currentView.fireEvent('editdetails', win.currentView, rec);
				},
				scope: this
			    },
			    'eventcancel': {
				fn: function(win, rec, animTarget) {
				    this.dismissEventEditor(null, animTarget);
				    win.currentView.onEventEditorCancel();
				},
				scope: this
			    }
			}
		    });
		    // this.editWin.remove('ext-cal-editwin-delete-btn', true);
		}

		// allows the window to reference the current scope in its callbacks
		this.editWin.currentView = this;
		return this.editWin;
	    },
	    
	    isEventVisible: function(evt) {
		var eventMappings = Extensible.calendar.data.EventMappings,
		    calendarMappings = Extensible.calendar.data.CalendarMappings,
		    data = evt.data || evt;
		var calRec = null;
		if(this.calendarStore) {
		    calRec = this.calendarStore.findRecord(calendarMappings.CalendarId.name,
							   evt[eventMappings.CalendarId.name]);
		}

		if (calRec && calRec.data[calendarMappings.IsHidden.name] === true) {
		    // if the event is on a hidden calendar then no need to test the date boundaries
		    return false;
		}

		// si le owner de l'event n'est pas checké on n'affiche pas

		owner = data['Owner'];
		// si le bouton de l'agenda est pressé, on affiche aucun
		calShortName = data['CalendarName'];
		calButton = Ext.getCmp(calShortName + '-button');
		if(!calButton.pressed) {
		    return false;
		}
		// si le user est dans la liste des non visible, on affiche pas
		if(AxAgenda.model.UsersStates[calShortName].notVisible.indexOf(owner) != -1) {
		    return false;
		}
		var start = this.viewStart.getTime(),
		    end = this.viewEnd.getTime(),
		    evStart = data[eventMappings.StartDate.name].getTime(),
		    evEnd = data[eventMappings.EndDate.name].getTime();

		return Extensible.Date.rangesOverlap(start, end, evStart, evEnd);
	    },

	    jeUserListPanel: this.jeUserListPanel,
	    jdUserListPanel: this.jdUserListPanel
	});

		     
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
            CalendarName:{name: 'CalendarName', mapping: 'cname', type: 'string'},	    
            Title:       {name: 'Title', mapping: 'title'},
            StartDate:   {name: 'Start', mapping: 'start', type: 'date', dateFormat: 'c'},
            EndDate:     {name: 'End', mapping: 'end', type: 'date', dateFormat: 'c'},
            Location:    {name: 'Location', mapping: 'location'},
            Notes:       {name: 'Notes', mapping: 'notes'},
            Url:         {name: 'Url', mapping: 'url'},
            IsAllDay:    {name: 'IsAllDay', mapping: 'all_day', type: 'boolean'},
	    IsFinished:  {name: 'IsFinished', mapping: 'is_finished', type: 'boolean'},
            Reminder:    {name: 'Reminder', mapping: 'reminder'},
	    Owner:       {name: 'Owner',    mapping: 'owner'},
	    Contact:     {name: 'Contact',  mapping: 'contact'},
	    ContactMail:  {name: 'ContactMail', mapping: 'contact.email'},
	    ContactPhone:       {name: 'ContactPhone',  mapping: 'contact.phone'},
	    ContactPhonePerso:  {name: 'ContactPhonePerso',  mapping: 'contact.phone_perso'},
	    ContactPhoneMobile:  {name: 'ContactPhoneMobile',  mapping: 'contact.phone_mobile'}	    	    

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
		type: 'rest',
		url: '/calendars', // SUBSTITUTE FOR DEPLOY		
		noCache: false,
		reader: {
                    type: 'json',
                    root: 'calendars'
		},
		writer: {
                    type: 'json',
                    nameProperty: 'mapping'
		}
            }
	});

	
	var eventStore = Ext.create('Extensible.calendar.data.EventStore', {
            autoLoad: true,
            proxy: {
		type: 'rest',
		noCache: false,
		pageParam: null,
		startParam: null,
		limitParam: null,
		url: '/events', // SUBSTITUTE FOR DEPLOY		
		reader: {
                    type: 'json',
                    root: 'events'
		},
		writer: {
                    type: 'json',
                    nameProperty: 'mapping'
		}
            },

            // listeners: {
	    // 	'write': function(store, operation) {
            //         var title = Ext.value(operation.records[0].data[Extensible.calendar.data.EventMappings.Title.name], '(No title)');
            //         switch(operation.action){
            //         case 'create':
            //             Extensible.example.msg('Add', 'Added "' + title + '"');
            //             break;
            //         case 'update':
            //             Extensible.example.msg('Update', 'Updated "' + title + '"');
            //             break;
            //         case 'destroy':
            //             Extensible.example.msg('Delete', 'Deleted "' + title + '"');
            //             break;
            //         }
	    // 	}
            // }
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
	    title: 'Utilisateurs Jobenfance',
	    agenda: 'je',
	    id: 'je-user-list-panel',
	    calendarStore: calendarStore,
	    eventStore: eventStore
	});

	var jdUserListPanel = Ext.create('AxAgenda.view.UserListPanel', {
	    title: 'Utilisateurs Jobdependance',
	    agenda: 'jd',
	    id: 'jd-user-list-panel',
	    calendarStore: calendarStore,
	    eventStore: eventStore
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

