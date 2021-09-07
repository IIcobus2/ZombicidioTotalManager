global class VacinaSim implements Database.Batchable<SObject> {
    private Id ZumbiId = Schema.SObjectType.Criatura__c.getRecordTypeInfosByName().get('Zumbi').getRecordTypeId();
    private Id HumanoId = Schema.SObjectType.Criatura__c.getRecordTypeInfosByName().get('Humano').getRecordTypeId();

    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator([SELECT id, Data_de_Zumbificacao__c, Tipo_do_Zumbi__c, Defesa_Criatura__c, RecordTypeId FROM Criatura__c]);
    }
    global void execute(Database.BatchableContext info, List<Criatura__c> scope) {
        List<Criatura__c> criList = (List<Criatura__c>) scope;
        List<Criatura__c> zumList = preencheListaCriaturaPorRecordtype(ZumbiId, criList);
        for (Criatura__c zl : zumList) {
            if (zumList.size() == 0) {
                break;
            }
            if (zl.Data_de_Zumbificacao__c == null) {
                System.debug('Zombie Defeituoso');
            }
            if ((zl.Data_de_Zumbificacao__c + 10) < Date.today()) {
                zl.RecordTypeId = HumanoId;
                zl.Data_de_Zumbificacao__c = null;
                zl.Tipo_do_Zumbi__c = null;
                zl.Defesa_Criatura__c = 0;
            }
        }
        update zumList;
    }

    private List<Criatura__c> preencheListaCriaturaPorRecordtype(id recordType, List<Criatura__c> listaP) {
        List<Criatura__c> cri = new List<Criatura__c>();
        for (Criatura__c crip : listaP) {
            if (crip.recordTypeId == recordType) {
                cri.add(crip);
            }
        }
        return cri;
    }

    global void finish(Database.BatchableContext info) {
    }
}
