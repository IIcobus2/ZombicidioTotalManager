global class ContagiarBatchable implements Database.Batchable<SObject> {
    private String ZumbiId = Schema.SObjectType.Criatura__c.getRecordTypeInfosByName().get('Zumbi').getRecordTypeId();
    private String HumanoId = Schema.SObjectType.Criatura__c.getRecordTypeInfosByName().get('Humano').getRecordTypeId();

    static final integer ZumbiSpread = 2;

    public ContagiarBatchable() {
    }
    // public Iterable start(Database.BatchableContext info) {
    //     return new CustomAccountIterable();
    // }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            [
                SELECT
                    id,
                    Criatura__c.RecordTypeId,
                    (SELECT id, Acrescimo_de_Defesa__c FROM Recursos_da_Criatura__r),
                    Bunker__c,
                    Bunker__r.Defesa_do_Bunker__c
                FROM Criatura__c
            ]
        );
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        System.debug('Entrou no execute');
        List<Criatura__c> criList = (List<Criatura__c>) scope;
        Map<id, Criatura__c> criUpdateList = new Map<id, Criatura__c>();
        // List<Criatura__c> criUpdateList = new List<Criatura__c>();
        List<Criatura__c> humList = preencheListaCriaturaRecordtype(HumanoId, criList);
        List<Criatura__c> zumList = preencheListaCriaturaRecordtype(ZumbiId, criList);
        for (Criatura__c zum : zumList) {
            for (integer i = 0; i < ZumbiSpread; i++) {
                Criatura__c cri = (Criatura__c) Util.GetRandomItem(humList);
                Decimal defesa = this.calculaDefesa(cri);
                Integer DiceRoll = Math.mod(Integer.valueof(Math.random() * 100000), 100) + 1;
                if (defesa < DiceRoll) {
                    cri.recordtypeId = ZumbiId;
                    cri.Data_de_Zumbificacao__c = Date.today();
                    criUpdateList.put(cri.id, cri);
                }
            }
        }
        update criUpdateList.values();
    }

    private Decimal calculaDefesa(Criatura__c hmn1) {
        Decimal defesa = 0;
        if (hmn1.Bunker__c != null) {
            defesa += hmn1.Bunker__r.Defesa_do_Bunker__c;
        }
        // Verificar se humano possui recursos - check
        if (hmn1.Recursos_da_Criatura__r != null) {
            for (Recurso_da_Criatura__c rc : hmn1.Recursos_da_Criatura__r) {
                defesa += rc.Acrescimo_de_Defesa__c;
            }
        }
        return defesa;
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

    global void finish(Database.BatchableContext BC) {
    }
}
