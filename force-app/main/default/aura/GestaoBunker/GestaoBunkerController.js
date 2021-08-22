({
    init: function (cmp, event, helper) {
        helper.getBunkers(cmp, event);
    },

    handleChange: function (cmp, event, helper) {
        var selectedOptionValue = event.getParam("value");
        cmp.set("v.columns", [
            { label: "Nome da Criatura", fieldName: "nomeCriatura", type: "text" },
            { label: "Tipo da Criatura", fieldName: "tipoCriatura", type: "text" },
            { label: "Defesa da criatura", fieldName: "defesaCriatura", type: "number" },
            { label: " ", fieldName: "verCriatura", type: "function" },
            { label: " ", fieldName: "expulsarCriatura", type: "function" }
        ]);
        helper.scriptsLoaded(cmp, selectedOptionValue);
        helper.getSelectedBunker(cmp, selectedOptionValue);
    }
});
