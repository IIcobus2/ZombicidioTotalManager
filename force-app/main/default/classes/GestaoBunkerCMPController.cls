public class GestaoBunkerCMPController {
    @AuraEnabled
    public static List<Bunker__c> recuperaBunkers() {
        return [SELECT Id, Name FROM Bunker__c LIMIT 200];
    }

    @AuraEnabled
    public static List<Criatura__c> recuperaCriaturas() {
        return [
            SELECT Id, Name
            FROM Criatura__c
            WHERE Bunker__c = NULL AND RecordTypeId = '0125e000000Rg6VAAS'
            LIMIT 200
        ];
    }

    @AuraEnabled
    public static Bunker recuperaBunkerMembros(String bunkerId) {
        Bunker bunkerToReturn = new Bunker();

        List<Criatura__c> criaturas = [
            SELECT
                id,
                Name,
                RecordType.name,
                Bunker__r.name,
                Bunker__r.Capacidade__c,
                Bunker__r.Ativo__c,
                Bunker__r.Defesa_do_Bunker__c,
                Bunker__r.Acrescimo_de_Defesa__c,
                Bunker__r.Populacao__c,
                (SELECT Acrescimo_de_Defesa__c FROM Recursos_da_Criatura__r)
            FROM Criatura__c
            WHERE Bunker__c = :bunkerId
            LIMIT 200
        ];
        if (!criaturas.isEmpty()) {
            bunkerToReturn.ativo = criaturas[0].Bunker__r.Ativo__c;
            bunkerToReturn.nome = criaturas[0].Bunker__r.name;
            bunkerToReturn.capacidade = Integer.valueOf(criaturas[0].Bunker__r.Capacidade__c);
            bunkerToReturn.populacao = Integer.valueOf(criaturas[0].Bunker__r.Populacao__c);
            bunkerToReturn.defesa = criaturas[0].Bunker__r.Defesa_do_Bunker__c;

            bunkerToReturn.percentHumanos = getPercentualHumanos(criaturas);
            bunkerToReturn.percentZumbis = getPercentualZumbis(criaturas);
            bunkerToReturn.percentLotacao =
                criaturas[0].Bunker__r.Populacao__c.divide(criaturas[0].Bunker__r.Capacidade__c, 2) * 100;
            bunkerToReturn.membrosDoBunker = getMembrosBunker(criaturas);
        }

        return bunkerToReturn;
    }

    private static Decimal getPercentualHumanos(List<Criatura__c> criaturas) {
        Decimal percentHumano = 0;
        Decimal totalCriaturas = criaturas.size();
        Decimal totalHumano = 0;
        for (Criatura__c criatura : criaturas) {
            if (criatura.recordtype.Name == 'Humano') {
                totalHumano = totalHumano + 1;
            }
        }
        percentHumano = totalHumano.divide(totalCriaturas, 2) * 100;
        return percentHumano;
    }

    private static Decimal getPercentualZumbis(List<Criatura__c> criaturas) {
        Decimal percentZumbi = 0;
        Decimal totalCriaturas = criaturas.size();
        Decimal totalZumbi = 0;
        for (Criatura__c criatura : criaturas) {
            if (criatura.recordtype.Name == 'Zumbi') {
                totalZumbi++;
            }
        }
        percentZumbi = totalZumbi.divide(totalCriaturas, 2) * 100;
        return percentZumbi;
    }

    private static List<MembroDoBunker> getMembrosBunker(List<Criatura__c> criaturas) {
        List<MembroDoBunker> membros = new List<MembroDoBunker>();
        for (Criatura__c criatura : criaturas) {
            System.debug('>>> criatura.Name :: ' + criatura.Name);
            MembroDoBunker membro = new MembroDoBunker();
            membro.sfId = criatura.Id;
            membro.nome = criatura.Name;
            membro.tipo = criatura.RecordType.name;
            membro.defesa = calculaDefesaCriatura(criatura.Recursos_da_Criatura__r);
            membros.add(membro);
        }
        return membros;
    }

    @AuraEnabled
    public static void setCriaturaNoBunker(Id recordIdCriatura, Id recordIdBunker) {
        try {
            Criatura__c cri = new Criatura__c();

            cri.id = recordIdCriatura;
            cri.bunker__c = recordIdBunker;

            update cri;
        } catch (Exception e) {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Decimal calculaDefesaCriatura(List<Recurso_da_Criatura__c> recursosCriatura) {
        Decimal defesa = 0;
        for (Recurso_da_Criatura__c recursoCriatura : recursosCriatura) {
            Decimal acrescimo = recursoCriatura.Acrescimo_de_Defesa__c;
            defesa = defesa + acrescimo;
        }
        return defesa / 100;
    }

    public class Bunker {
        @AuraEnabled
        public Boolean ativo;
        @AuraEnabled
        public Id sfId;
        @AuraEnabled
        public String nome;
        @AuraEnabled
        public Integer capacidade;
        @AuraEnabled
        public Integer populacao;
        @AuraEnabled
        public Decimal defesa;
        @AuraEnabled
        public Decimal percentHumanos;
        @AuraEnabled
        public Decimal percentZumbis;
        @AuraEnabled
        public Decimal percentLotacao;
        @AuraEnabled
        public List<MembroDoBunker> membrosDoBunker;
    }

    public class MembroDoBunker {
        @AuraEnabled
        public Id sfId;
        @AuraEnabled
        public String nome;
        @AuraEnabled
        public String tipo;
        @AuraEnabled
        public Decimal defesa;
    }
}
