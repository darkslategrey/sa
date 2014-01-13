


Ext.define('AxAgenda.view.Viewport', {
    extend: 'Ext.container.Viewport',

    requires: ['Ext.container.Viewport', 'AxAgenda.view.MainPanel'],


    renderTo: 'calendar-ct',
    layout: 'border',
    
    items: [
	{
	    xtype: 'axagenda.mainpanel'
	}
    ]
});
