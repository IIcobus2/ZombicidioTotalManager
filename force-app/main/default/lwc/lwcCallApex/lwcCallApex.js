import { LightningElement, wire, api } from "lwc";

import getHerois from "@salesforce/apex/CalloutToSalesforce.getHeroisBootcamp3";

export default class LwcCallApex extends LightningElement {
    @api herois = [];

    // Wire = mais prático porém mais flexivel

    // @wire(getHerois)
    // wiredRecord({ error, data }) {
    //     if (data) {
    //         console.log(data);
    //         this.herois = data.herois;
    //     } else {
    //         console.log(error);
    //     }
    // }

    // Then/Catch = mais flexível porém mais trabalhoso
    // não precisa do if no html

    connectedCallback() {
        getHerois()
            .then((result) => {
                this.herois = result.herois;
                console.log(this.herois);
            })
            .catch((error) => {
                console.log(error);
            });
    }
}
