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
    }
});
