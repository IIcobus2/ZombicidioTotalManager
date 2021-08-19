trigger CriaturaTrigger on Criatura__c (after insert, after update, after delete) {
	//List<Criatura__c> criList = [SELECT id FROM Criatura__c WHERE id in : trigger.newMap.keyset()];
    Map<id,Bunker__c> bunkersUpdateMap = new Map<id,Bunker__c>();
    
    for (Criatura__c cr : trigger.new){
        
        Criatura__c nova = cr;
        Criatura__c antiga = trigger.oldMap.get(cr.Id);
        if(cr.Bunker__c != antiga.Bunker__c){
            bunkersUpdateMap.put(cr.Bunker__c,new Bunker__c(id = cr.Bunker__c));
        }
    }
    for(Criatura__c cr : trigger.old){
        if (trigger.isDelete && cr.Bunker__c != NULL){
            bunkersUpdateMap.put(cr.Bunker__c, new Bunker__c(id = cr.Bunker__c));
        }
    }
    System.debug(bunkersUpdateMap);
    
    List<Bunker__c> bkList = [SELECT id, (SELECT id from Criaturas__r) FROM bunker__c WHERE id in :bunkersUpdateMap.keySet()];
    for(Bunker__c bk : bkList){
        bunkersUpdateMap.get(bk.Id).Populacao__c = bk.Criaturas__r.size();
    }
    update bunkersUpdateMap.values();
}