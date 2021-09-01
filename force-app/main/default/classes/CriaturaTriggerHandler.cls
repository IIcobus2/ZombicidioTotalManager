public class CriaturaTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        this.AtualizaPopulacaoBunker(
            Trigger.operationType,
            (List<Criatura__c>) Trigger.new,
            new Map<Id, Criatura__c>()
        );
    }
    public override void afterUpdate() {
        this.AtualizaPopulacaoBunker(
            Trigger.operationType,
            (List<Criatura__c>) Trigger.new,
            (Map<Id, Criatura__c>) Trigger.oldMap
        );
    }
    public override void afterDelete() {
        this.AtualizaPopulacaoBunker(
            Trigger.operationType,
            (List<Criatura__c>) Trigger.old,
            (Map<Id, Criatura__c>) Trigger.oldMap
        );
    }

    private void AtualizaPopulacaoBunker(
        System.TriggerOperation opType,
        List<Criatura__c> triggerNew,
        Map<Id, Criatura__c> triggerOldMap
    ) {
        Map<id, Bunker__c> bunkersUpdateMap = new Map<id, Bunker__c>();

        for (Criatura__c cr : triggerNew) {
            Criatura__c crOld = triggerOldMap.get(cr.id);
            AdicionaBunkerParaAtualizacao(opType, cr, crOld, bunkersUpdateMap);
        }
        TotalizaPopupacaoBunker(bunkersUpdateMap);
        update bunkersUpdateMap.values();
    }

    private Boolean CriaturaNovaCoMBunker(System.TriggerOperation opType, Criatura__c cr) {
        return opType == System.TriggerOperation.AFTER_INSERT && cr.Bunker__c != null;
    }
    private Boolean CriaturaEntrouBunker(System.TriggerOperation opType, Criatura__c cr, Criatura__c crOld) {
        return opType == System.TriggerOperation.AFTER_UPDATE &&
            cr.Bunker__c != crOld.Bunker__c &&
            cr.Bunker__c != null;
    }
    private Boolean CriaturaSaiuBunker(System.TriggerOperation opType, Criatura__c cr, Criatura__c crOld) {
        return opType == System.TriggerOperation.AFTER_UPDATE &&
            cr.Bunker__c != crOld.Bunker__c &&
            crOld.Bunker__c != null;
    }
    private Boolean CriaturaBunkerDeletada(System.TriggerOperation opType, Criatura__c crOld) {
        return opType == System.TriggerOperation.AFTER_DELETE && crOld.Bunker__c != null;
    }

    private void TotalizaPopupacaoBunker(Map<id, Bunker__c> bunkersUpdateMap) {
        List<Bunker__c> bkList = [
            SELECT id, (SELECT id FROM Criaturas__r)
            FROM bunker__c
            WHERE id IN :bunkersUpdateMap.keySet()
        ];
        for (Bunker__c bk : bkList) {
            System.debug(bk.Criaturas__r);
            bunkersUpdateMap.get(bk.Id).Populacao__c = bk.Criaturas__r.size();
        }
    }

    private void AdicionaBunkerParaAtualizacao(
        System.TriggerOperation opType,
        Criatura__c cr,
        Criatura__c crOld,
        Map<id, Bunker__c> bunkersUpdateMap
    ) {
        if (CriaturaNovaCoMBunker(opType, cr) || CriaturaEntrouBunker(opType, cr, crOld)) {
            bunkersUpdateMap.put(cr.bunker__c, new Bunker__c(id = cr.bunker__c));
        }

        if (CriaturaSaiuBunker(opType, cr, crOld) || CriaturaBunkerDeletada(opType, crOld)) {
            bunkersUpdateMap.put(crOld.bunker__c, new Bunker__c(id = crOld.bunker__c));
        }
    }
}
