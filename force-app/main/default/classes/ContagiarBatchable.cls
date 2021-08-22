public class ContagiarBatchable implements Database.Batchable<Criatura__c> {
    //public ContagiarBatchable() {}
    public Iterable start(Database.BatchableContext info) {
        return new CustomAccountIterable();
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT id, Criatura__c.RecordTypeId (SELECT id, Acrescimo_de_Defesa__c FROM Recursos_da_Criatura__r), Bunker__c, Bunker__r.Defesa_do_Bunker__c FROM Criatura__c'
        );
    }

    public void execute(Database.BatchableContext BC, List<Criatura__c> scope) {
        List<Criatura__c> hum = preencheListaCriaturaRecordtype('0125e000000Rg6VAAS');
        List<Criatura__c> zom = new List<Criatura__c>();
    }

    private List<Criatura__c> preencheListaCriaturaRecordtype(id recordType, List<Criatura__c> listaP) {
        List<Criatura__c> cri = new List<Criatura__c>();
        for (Criatura__c crip : listaP) {
            if (crip.recordTypeId == recordType) {
                cri.add(crip);
            }
        }
        return cri;
    }

    public void finish(Database.BatchableContext BC) {
    }
}
