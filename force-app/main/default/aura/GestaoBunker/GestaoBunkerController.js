({
    init: function (cmp, event, helper) {
        helper.getBunkers(cmp, event);
    },

    handleChange: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
        const card2 = document.querySelector("[data-js='campo2']");
        card2.style.display = "block";

        // cmp.set("v.options", items);
    }
});
