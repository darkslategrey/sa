


Ext.define('Axagenda.gadget.UserListCombo', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.axagenda.userlist',

    displayField: 'nom',
    valueField: 'id',
    multiSelect: true


    // listeners: {
    // 	'select': userFilter(this.getValue)
    // },

    // userFilter: function(userId) {
    // }
    
});
