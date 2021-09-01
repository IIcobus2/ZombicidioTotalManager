public with sharing class RecursoCriaturaTriggerHandler extends TriggerHandler {
}

// List<Recurso_do_Bunker__c> recursoBunker = Trigger.new;
// List<Recurso_do_Bunker__c> recursoBunkerOld = Trigger.old;

// Decimal defesaItens = 0;
// if (recursoBunker != null) {
//     Bunker__c bunker = [SELECT id, Defesa_do_Bunker__c FROM Bunker__c WHERE id = :recursoBunker[0].Bunker__c];
//     List<Recurso_do_Bunker__c> listaRecursoBunker = [
//         SELECT Id, Bunker__c, Bunker__r.Defesa_do_Bunker__c, Recurso__r.Acrescimo_de_Defesa__c, Quantidade__c
//         FROM Recurso_do_bunker__c
//         WHERE Bunker__c = :recursoBunker[0].Bunker__c
//     ];

//     for (Recurso_do_Bunker__c rb : listaRecursoBunker) {
//         defesaItens += (rb.Quantidade__c * rb.Recurso__r.Acrescimo_de_Defesa__c);
//     }

//     bunker.Defesa_do_Bunker__c = defesaItens;
//     update bunker;
// } else {
//     Bunker__c bunker = [SELECT id, Defesa_do_Bunker__c FROM Bunker__c WHERE id = :recursoBunkerOld[0].Bunker__c];
//     List<Recurso_do_Bunker__c> listaRecursoBunkerOld = [
//         SELECT Id, Bunker__c, Bunker__r.Defesa_do_Bunker__c, Recurso__r.Acrescimo_de_Defesa__c, Quantidade__c
//         FROM Recurso_do_bunker__c
//         WHERE Bunker__c = :recursoBunkerOld[0].Bunker__c
//     ];
//     for (Recurso_do_Bunker__c rb : listaRecursoBunkerOld) {
//         defesaItens += (rb.Quantidade__c * rb.Recurso__r.Acrescimo_de_Defesa__c);
//     }

//     bunker.Defesa_do_Bunker__c = defesaItens;
//     update bunker;
// }

