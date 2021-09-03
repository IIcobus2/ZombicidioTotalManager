import { LightningElement, api } from "lwc";

const columns = [
    { label: "Nome do Heroi", fieldName: "nome" },
    { label: "Nível do Heroi", fieldName: "nivel" },
    { label: "Total de Habilidades", fieldName: "totalHabilidades", type: "number" }
];

export default class LwcChild extends LightningElement {
    @api
    heroisDados = [];
    columns = columns;
}
