({
    init: function (cmp, event, helper) {
        helper.getBunkers(cmp, event);
    },

    handleChange: function (cmp, event, helper) {
        var selectedOptionValue = event.getParam("value");
        var campo2 = document.querySelector('[data-js="campo2"]');
        campo2.style.display = "block";
        cmp.set("v.columns", [
            { label: "Nome da Criatura", fieldName: "nomeCriatura", type: "text" },
            { label: "Tipo da Criatura", fieldName: "tipoCriatura", type: "text" },
            { label: "Defesa da criatura", fieldName: "defesaCriatura", type: "number" },
            { label: " ", fieldName: "verCriatura", type: "function" },
            { label: " ", fieldName: "expulsarCriatura", type: "function" }
        ]);
        // submitForm(cmp, event, helper, selectedOptionValue);
        // if (chart.childNodes[0]) chart.innerHTML = " ";
        helper.scriptsLoaded(cmp, selectedOptionValue);
        helper.getSelectedBunker(cmp, selectedOptionValue);
    },

    handleKeyUp: function (cmp, evt) {
        // var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = cmp.find("enter-search").get("v.value");
            alert('Searched for "' + queryTerm + '"!');
        }
    },
    submitForm: function (cmp, event, helper, recordIdBunker) {
        var inputCmp = cmp.find("inputCmp");
        // var value = inputCmp.get("v.value");
        // is input valid text?
        // helper.getSelectedBunkercmp(cmp, recordIdBunker);
        // if (value === "John Doe") {
        //     inputCmp.setCustomValidity("John Doe is already registered");
        //     // verifica se está no bunker
        // } else {
        //     inputCmp.setCustomValidity(""); // if there was a custom error before, reset it
        //     // insert no bunker
        // }
        // inputCmp.reportValidity(); // Tells lightning:input to show the error right away without needing interaction
    },

    showModal: function (cmp, event, helper) {
        document.getElementById("newClientSectionId").style.display = "block";
    },

    hideModal: function (cmp, event, helper) {
        document.getElementById("newClientSectionId").style.display = "none";
    }
});
