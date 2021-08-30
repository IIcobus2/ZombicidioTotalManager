({
    init: function (component, event, helper) {
        console.log(">>> INIT <<<");
        helper.carregaBunkers(component, event);
        helper.setColumns(component);
    },

    handleChange: function (component, event, helper) {
        helper.selecionarBunker(component, event);
    },
    handleChange2: function (component, event, helper) {
        let selectedCreature = event.getParam("value");
        component.set("v.criaturaSelecionada", selectedCreature);
    },
    handleClick: function (component, event, helper) {
        let selectedCreature = component.get("v.criaturaSelecionada");
        helper.setNovoMembro(component, event, selectedCreature);
    },
    showModal: function (component, event, helper) {
        component.set("v.showModal", true);
        helper.carregaCriaturas(component, event);
    },
    viewRecord: function (component, event, helper) {
        helper.viewRecord(component, event);
    },

    closeModal: function (component, event, helper) {
        component.set("v.showModal", false);
    }
});
