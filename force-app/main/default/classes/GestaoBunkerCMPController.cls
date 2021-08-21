public class GestaoBunkerCMPController {
    // public GestaoBunkerCMPController() {
    // }
    @AuraEnabled
    public static List<Bunker__c> recuperaBunkers() {
        try {
            List<Bunker__c> bunkersToReturn = new List<Bunker__c>();

            bunkersToReturn = [
                SELECT Id, Name, Defesa_do_Bunker__c, Populacao__c, (SELECT Id, Name FROM Criaturas__r)
                FROM Bunker__c
            ];

            return bunkersToReturn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
