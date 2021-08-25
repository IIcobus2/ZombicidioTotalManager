trigger CriaturaTrigger on Criatura__c(after insert, after update, after delete) {
    //List<Criatura__c> criList = [SELECT id FROM Criatura__c WHERE id in : trigger.newMap.keyset()];
    Map<id, Bunker__c> bunkersUpdateMap = new Map<id, Bunker__c>();

    for (Criatura__c cr : Trigger.new) {
        Criatura__c nova = cr;
        Criatura__c antiga = Trigger.oldMap.get(nova.Id);
        if (nova.Bunker__c != antiga.Bunker__c) {
            if (nova.Bunker != null) {
                bunkersUpdateMap.put(nova.Bunker__c, new Bunker__c(id = nova.Bunker__c));
            }
            if (antiga.Bunker__c != null) {
                bunkersUpdateMap.put(antiga.Bunker__c, new Bunker__c(id = antiga.Bunker__c));
            }
        }
    }
    for (Criatura__c cr : Trigger.old) {
        if (Trigger.isDelete && cr.Bunker__c != null) {
            bunkersUpdateMap.put(cr.Bunker__c, new Bunker__c(id = cr.Bunker__c));
        }
    }
    System.debug(bunkersUpdateMap);

    List<Bunker__c> bkList = [
        SELECT id, (SELECT id FROM Criaturas__r)
        FROM bunker__c
        WHERE id IN :bunkersUpdateMap.keySet()
    ];
    for (Bunker__c bk : bkList) {
        System.debug(bk.Crituras__r);
        bunkersUpdateMap.get(bk.Id).Populacao__c = bk.Criaturas__r.size();
    }
    update bunkersUpdateMap.values();
}
