public class AdicionaRecursosCriaturaCMPController {
    @AuraEnabled
    public static List<Recurso__c> recuperaRecursos(String recordId) {
        List<Recurso__c> recursosToReturn = new List<Recurso__c>();

        Set<Id> recursosIds = new Set<Id>();

        for (Recurso_da_Criatura__c recursoCriatura : [
            SELECT Id, Criatura__r.Name, Recurso__r.Name
            FROM Recurso_da_Criatura__c
            WHERE Criatura__c = :recordId
        ]) {
            recursosIds.add(recursoCriatura.Recurso__c);
        }
        recursosToReturn = [SELECT Id, Name FROM Recurso__c WHERE Id NOT IN :recursosIds LIMIT 200];

        return recursosToReturn;
    }
}
