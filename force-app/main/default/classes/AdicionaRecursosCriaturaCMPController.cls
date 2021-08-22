public class AdicionaRecursosCriaturaCMPController {
    @AuraEnabled
    public static List<Recurso__c> recuperaRecursos(String recordId) {
        List<Recurso__c> recursosToReturn = new List<Recurso__c>();
        Set<Id> recursosIds = new Set<Id>();

        for (Recurso_da_Criatura__c recursoCriatura : [
            SELECT Id, Recurso__c
            FROM Recurso_da_Criatura__c
            WHERE Criatura__c = :recordId
        ]) {
            recursosIds.add(recursoCriatura.Recurso__c);
        }

        recursosToReturn = [SELECT Id, Name FROM Recurso__c WHERE Id NOT IN :recursosIds LIMIT 200];

        return recursosToReturn;
    }

    @AuraEnabled
    public static void adicionarRecursoCriatura(String criaturaId, String recursoId) {
        Recurso_da_Criatura__c recursoCriatura = new Recurso_da_Criatura__c();
        recursoCriatura.Criatura__c = criaturaId;
        recursoCriatura.Recurso__c = recursoId;

        insert recursoCriatura;
    }
}
