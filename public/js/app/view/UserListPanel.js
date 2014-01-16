
Ext.define('AxAgenda.view.UserListPanel', {
    extend: 'Ext.panel.Panel',
    layout: 'fit',
    alias: 'widget.axagenda.userlistpanel',

    requires: [ 'AxAgenda.model.UsersStates' ],
    
    store: null,
    calendarStore: null,
    eventStore: null,

    controllers: ['Calendars'],

    
    initComponent: function() {
	Ext.apply(this, {
	    renderTo: Ext.getBody(),
	    tbar: [{
		text: 'Tous / Aucun',
		id: this.agenda + '-button',
		pressed: true,
		enableToggle: true,
		toggleHandler: function(button, pressed){
		    this.items.get(0).items.each(function(checkbox){
			checkbox.setValue(pressed);
		    }, this);
		},
		scope: this
	    }]
	});
	this.ajaxLoadUsers();
	this.callParent(arguments);	
    },

    ajaxLoadUsers: function(){
	Ext.Ajax.request({
	    url: '/users?agenda='+this.agenda, // SUBSTITUTE FOR DEPLOY
	    success: function(response){
		console.log(response);
		var jsonResponse = Ext.decode(response.responseText);
		if(jsonResponse.success) {
		    this.addUsers(jsonResponse);
		} else {
		    console.log("Error when loading users");
		}
	    },
	    scope: this
	});
    },

    addUsers: function(jsonResponse) {
	var i, len = jsonResponse.users.length, user;
	var checkboxgroup = {
	    xtype: 'checkboxgroup',

	    fieldLabel: '',
	    columns: 1,
	    items: []
	};
	checkboxgroup.id = this.agenda + '-users-checkboxgroup';
	for(i = 0; i < len; i++) {
	    user = jsonResponse.users[i];

	    AxAgenda.model.UsersStates[this.agenda].allUsers.push(user.id);
	    if(user.selected) {
		AxAgenda.model.UsersStates[this.agenda].visible.push(user.id);
	    } else {
		AxAgenda.model.UsersStates[this.agenda].notVisible.push(user.id);
	    }
	    checkboxgroup.items.push({
		xtype: 'checkbox',
		boxLabel: user.nom,
		name: 'user',
		inputValue: user.id,
		checked: user.selected
		// listeners: {
		//     change: this.onChange
		// }
	    });
	}
	this.add(checkboxgroup);	
    },

    // onChange: function(nv, ov, opts) {
    // 	console.log("nv <"+nv+"> ov <"+ov+"> <"+opts);
    // }
    
    // requires: [
    //     'Ext.XTemplate',
    //     'Extensible.calendar.gadget.CalendarListMenu'
    // ],
    
    // initComponent: function() {
    //     this.addCls('x-calendar-list');
    //     this.callParent(arguments);
    // },

    // afterRender: function(ct, position) {
    //     this.callParent(arguments);
        
    //     if(this.store) {
    //         this.setStore(this.store, true);
    //     }
    //     this.refresh();
        
    //     this.body.on('click', this.onClick, this);
    //     this.body.on('mouseover', this.onMouseOver, this, {delegate: 'li'});
    //     this.body.on('mouseout', this.onMouseOut, this, {delegate: 'li'});
    // },
    
    // refresh: function() {
    //     if(this.skipRefresh) {
    //         return;
    //     }
    //     var data = [], i = 0, o = null,
    //         CM = Extensible.calendar.data.CalendarMappings,
    //         recs = this.store.getRange(),
    //         len = recs.length;
            
    //     for (; i < len; i++) {
    //         o = {
    //             cmpId: this.id + '__' + recs[i].data[CM.CalendarId.name],
    //             title: recs[i].data[CM.Title.name],
    //             colorCls: this.getColorCls(recs[i].data[CM.ColorId.name])
    //         };
    //         if(recs[i].data[CM.IsHidden.name] === true) {
    //             o.hiddenCls = 'ext-cal-hidden';
    //         }
    //         data[data.length] = o;
    //     }
    //     this.getListTemplate().overwrite(this.body, data);
    // },

    // toggleCalendar: function(id, commit) {
    //     var rec = this.store.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, id),
    //         CM = Extensible.calendar.data.CalendarMappings,
    //         isHidden = rec.data[CM.IsHidden.name];
        
    //     rec.set(CM.IsHidden.name, !isHidden);
        
    //     if(commit !== false) {
    //         rec.commit();
    //     }
    // },
    
    // showCalendar: function(id, commit) {
    //     var rec = this.store.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, id);
    //     if(rec.data[Extensible.calendar.data.CalendarMappings.IsHidden.name] === true) {
    //         this.toggleCalendar(id, commit);
    //     }
    // },
    
    // hideCalendar: function(id, commit) {
    //     var rec = this.store.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, id);
    //     if(rec.data[Extensible.calendar.data.CalendarMappings.IsHidden.name] !== true) {
    //         this.toggleCalendar(id, commit);
    //     }
    // },

    // showEventMenu: function(el, xy) {
    //     var id = this.getCalendarId(el.parent('li')),
    //         rec = this.store.findRecord(Extensible.calendar.data.CalendarMappings.CalendarId.name, id),
    //         colorId = rec.data[Extensible.calendar.data.CalendarMappings.ColorId.name];
            
    //     if(!this.menu) {
    //         this.menu = Ext.create('Extensible.calendar.gadget.CalendarListMenu');
    //         this.menu.on('colorchange', this.handleColorChange, this);
    //         this.menu.on('radiocalendar', this.handleRadioCalendar, this);
    //     }
    //     this.menu.setCalendar(id, colorId);
    //     this.menu.showAt(xy);
    // },
    
    // getListTemplate: function() {
    //     if(!this.tpl) {
    //         this.tpl = !(Ext.isIE || Ext.isOpera) ?
    //             Ext.create('Ext.XTemplate',
    //                 '<ul class="x-unselectable"><tpl for=".">',
    //                     '<li id="{cmpId}" class="ext-cal-evr {colorCls} {hiddenCls}">{title}<em>&#160;</em></li>',
    //                 '</tpl></ul>'
    //             )
    //             : Ext.create('Ext.XTemplate',
    //                 '<ul class="x-unselectable"><tpl for=".">',
    //                     '<li id="{cmpId}" class="ext-cal-evo {colorCls} {hiddenCls}">',
    //                         '<div class="ext-cal-evm">',
    //                             '<div class="ext-cal-evi">{title}<em>&#160;</em></div>',
    //                         '</div>',
    //                     '</li>',
    //                 '</tpl></ul>'
    //             );
    //         this.tpl.compile();
    //     }
    //     return this.tpl;
    // },

    // setStore: function(store, initial) {
    //     if(!initial && this.store) {
    //         this.store.un("load", this.refresh, this);
    //         this.store.un("add", this.refresh, this);
    //         this.store.un("remove", this.refresh, this);
    //         this.store.un("update", this.onUpdate, this);
    //         this.store.un("clear", this.refresh, this);
    //     }
    //     if(store) {
    //         store.on("load", this.refresh, this);
    //         store.on("add", this.refresh, this);
    //         store.on("remove", this.refresh, this);
    //         store.on("update", this.onUpdate, this);
    //         store.on("clear", this.refresh, this);
    //     }
    //     this.store = store;
    // },
    
    
});
