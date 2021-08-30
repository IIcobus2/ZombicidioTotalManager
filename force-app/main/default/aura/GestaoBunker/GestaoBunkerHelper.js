({
    carregaBunkers: function (component, event) {
        let action = component.get("c.recuperaBunkers");
        component.set("v.showSpinner", true);

        action.setCallback(this, function (response) {
            let state = response.getState();
            let errors = response.getError();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);

                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.label = row.Name;
                    row.value = row.Id;
                }
                console.log("rows", rows);
                if (rows != null) {
                    component.set("v.options", rows);
                }
            }
        });
        $A.enqueueAction(action);
    },

    carregaCriaturas: function (component, event) {
        let action = component.get("c.recuperaCriaturas");
        component.set("v.showSpinner", true);

        action.setCallback(this, function (response) {
            let state = response.getState();
            let errors = response.getError();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);

                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.label = row.Name;
                    row.value = row.Id;
                }
                console.log("rows", rows);
                if (rows != null) {
                    component.set("v.optionsCriaturas", rows);
                }
            }
        });
        $A.enqueueAction(action);
    },

    setNovoMembro: function (component, event, selectedCreature) {
        let criaturaSelecionada = selectedCreature;
        let bunkerSelecionado = component.get("v.bunkerSelecionado");

        let action = component.get("c.setCriaturaNoBunker");
        component.set("v.showSpinner", true);

        action.setParams({
            recordIdCriatura: criaturaSelecionada,
            recordIdBunker: bunkerSelecionado
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.carregaMembros(component, event);
                this.showToast(component, event);
                component.set("v.showSpinner", false);
                this.closeModal(component, event);
            }
        });

        $A.enqueueAction(action);
    },

    closeModal: function (component, event) {
        component.set("v.showModal", false);
    },

    showToast: function (component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Sucesso!",
            message: "A criatura foi incluida no bunker com sucesso.",
            type: "success"
        });
        toastEvent.fire();
    },
    setColumns: function (component) {
        component.set("v.columns", [
            { label: "Membro", fieldName: "nome", type: "text" },
            { label: "Tipo de Criatura", fieldName: "tipo", type: "text" },
            { label: "Defesa", fieldName: "defesa", type: "percent" },
            {
                type: "button",
                typeAttributes: {
                    label: "Ver Criatura",
                    name: "View",
                    title: "Clique aqui para abrir este registro",
                    disabled: false,
                    value: "view",
                    iconPosition: "left"
                }
            },
            {
                type: "button",
                typeAttributes: {
                    label: "Editar/Expulsar",
                    name: "Edit",
                    title: "Clique aqui para editar este registro",
                    disabled: false,
                    value: "edit",
                    iconPosition: "left"
                }
            }
        ]);
    },

    carregaMembros: function (component, event) {
        let bunkerSelecionado = component.get("v.bunkerSelecionado");

        component.set("v.showSpinner", true);
        let action = component.get("c.recuperaBunkerMembros");
        action.setParams({
            bunkerId: bunkerSelecionado
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            let errors = response.getError();
            if (state === "SUCCESS") {
                var bunker = response.getReturnValue();

                console.log(">>> return:: ", bunker);
                if (bunker != null) {
                    component.set("v.bunkerInfo", bunker);
                    if (bunker.membrosDoBunker != null) {
                        component.set("v.data", bunker.membrosDoBunker);
                    }
                }
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    selecionarBunker: function (component, event) {
        let bunkerSelecionado = event.getParam("value");

        component.set("v.bunkerSelecionado", bunkerSelecionado);
        this.carregaMembros(component, event);
    },

    viewRecord: function (component, event) {
        var recId = event.getParam("row").sfId;
        var actionName = event.getParam("action").name;
        if (actionName == "Edit") {
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                recordId: recId
            });
            editRecordEvent.fire();
        } else if (actionName == "View") {
            var viewRecordEvent = $A.get("e.force:navigateToURL");
            viewRecordEvent.setParams({
                url: "/" + recId
            });
            viewRecordEvent.fire();
        }
    }
});
