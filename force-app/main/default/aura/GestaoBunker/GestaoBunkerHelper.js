({
    helperMethod: function () {},

    getBunkers: function (cmp, event) {
        var action = cmp.get("c.recuperaBunkers");

        // action.setParams();

        action.setCallback(this, (response) => {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                let rows = response.getReturnValue();
                for (let i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.label = row.Name;
                    row.value = row.Id;
                }
                console.log("rows ::", rows);

                if (rows) cmp.set("v.options", rows);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getSelectedBunker: function (cmp, recordIdBunker) {
        var action = cmp.get("c.dadosBunkerSelecionado");

        action.setParams({
            recordIdBunker: recordIdBunker
        });
        action.setCallback(this, (response) => {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                let rows = response.getReturnValue();
                for (let i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    for (let j = 0; j < row.Criaturas__r.length; j++) {
                        var row2 = row.Criaturas__r[j];
                        row2.nomeCriatura = row2.Name;
                        if (row2.RecordTypeId === "0125e000000Rg6VAAS") {
                            row2.tipoCriatura = "Humano";
                        } else {
                            row2.tipoCriatura = "Zumbi";
                        }
                        row2.defesaCriatura = row2.Defesa_Criatura__c;
                        // row.verCriatura = botaoVer;
                        // row.deletarCriatura = botaoDeletar;
                    }
                }
                // console.log("type:: ", typeof row.Criaturas__r, ">>>rows ::", row.Criaturas__r);

                cmp.set("v.data", row.Criaturas__r);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    scriptsLoaded: function (cmp, recordIdBunker) {
        var action = cmp.get("c.dadosGrafico");
        action.setParams({
            recordIdBunker: recordIdBunker
        });
        var chart;
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let val = response.getReturnValue();
                let dataset = [];
                var countZumbi = 0;
                var countHumano = 0;
                var bunkerName = "";
                for (let i = 0; i < val.length; i++) {
                    for (let j = 0; j < val[i].Criaturas__r.length; j++) {
                        var row = val[i].Criaturas__r[j];
                        if (row.RecordTypeId === "0125e000000Rg6VAAS") {
                            // row.RecordTypeId = "Humano";
                            countHumano++;
                        } else {
                            // row.RecordTypeId = "Zumbi";
                            countZumbi++;
                        }
                    }
                    if (recordIdBunker === val[0].Id) {
                        bunkerName = val[i].Name;
                        dataset.push(val[i].Defesa_do_Bunker__c);
                        var populacao = countZumbi + countHumano;
                        dataset.push(parseFloat((countHumano * 100) / populacao).toFixed(2));
                        dataset.push(parseFloat((countZumbi * 100) / populacao).toFixed(2));
                    } else {
                        console.log(">>>ERROR:: recordIdBunker === val[i].Id" + recordIdBunker === val[i].Id);
                    }
                }
                console.log("bunkerName:: ", bunkerName);
                console.log("dataset:: ", dataset);

                let ctx = document.getElementById("chart").getContext("2d");

                // var body = document.querySelector('[data-js="display-chart"]');

                new Chart(ctx, {
                    type: "horizontalBar",
                    data: {
                        labels: ["Defesa do Bunker (%)", "Humano (%)", "Zombie (%)"],
                        datasets: [
                            {
                                label: bunkerName,
                                backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9"],
                                data: dataset
                            }
                        ]
                    },
                    options: {
                        scales: {
                            xAxes: [
                                {
                                    type: "linear",
                                    min: 0,
                                    max: 100,
                                    stacked: false
                                }
                            ],
                            yAxes: [
                                {
                                    stacked: true
                                }
                            ]
                        },
                        plugins: {
                            datalabels: {
                                color: "white",
                                font: {
                                    weight: "bold"
                                },
                                formatter: "a" + "%"
                            }
                        }
                    }
                });
            }
        });

        $A.enqueueAction(action);
    },

    removeCriatura: function (cmp, row) {
        var rows = cmp.get("v.rawData");
        var rowIndex = this.getRowIndex(rows, row);

        rows.splice(rowIndex, 1);
        this.updateBooks(cmp);
    }
});
