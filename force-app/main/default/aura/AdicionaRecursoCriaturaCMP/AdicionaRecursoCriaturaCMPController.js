({
    doInit: function (component, event, helper) {
        helper.getRecursos(component, event);
    },
    handleChange: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        //component.set("v.recursoSelecionado", selectedOptionValue);
        alert("Option selected with value: '" + selectedOptionValue + "'");
    },
    salvar: function (component, event, helper) {
        helper.getRecursos(component, event);
    }
});
