public class GestaoBunkerCMPController {
    // public GestaoBunkerCMPController() {
    // }
    @AuraEnabled
    public static List<Bunker__c> recuperaBunkers() {
        try {
            List<Bunker__c> bunkersToReturn = new List<Bunker__c>();

            bunkersToReturn = [SELECT Id, Name FROM Bunker__c];

            return bunkersToReturn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Bunker__c> dadosBunkerSelecionado(String recordIdBunker) {
        try {
            List<Bunker__c> dadoBunker = new List<Bunker__c>();

            dadoBunker = [
                SELECT (SELECT Id, Name, RecordTypeId, Defesa_Criatura__c FROM Criaturas__r LIMIT 10)
                FROM Bunker__c
                WHERE Id = :recordIdBunker
            ];

            return dadoBunker;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Bunker__c> dadosGrafico(String recordIdBunker) {
        try {
            List<Bunker__c> retornaDadoGrafico = new List<Bunker__c>();

            retornaDadoGrafico = [
                SELECT Defesa_do_Bunker__c, (SELECT RecordTypeId FROM Criaturas__r)
                FROM Bunker__c
                WHERE Id = :recordIdBunker
            ];

            return retornaDadoGrafico;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
