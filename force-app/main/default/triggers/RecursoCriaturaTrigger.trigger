trigger RecursoCriaturaTrigger on Recurso_da_Criatura__c(after insert, after update, after delete) {
    new RecursoCriaturaTriggerHandler().run();
}
