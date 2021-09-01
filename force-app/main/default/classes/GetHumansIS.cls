@RestResource(urlMapping='/zumbicidio/humanos/*')
global class GetHumansIS {
    @HttpGet
    global static HumanosResponse doGet() {
        List<Criatura__c> criaturasToReturn = new List<Criatura__c>();
        String getreturn = 'Não possui humanos.';
        String recursoParam = RestContext.request.params.get('recurso');
        String bunkerName = RestContext.request.params.get('bunker');

        String dynamicQuery = 'SELECT id, name, idade__c, bunker__r.name  FROM Criatura__c WHERE RecordType.DeveloperName = \'Humano\'';

        if (!String.isBlank(bunkerName)) {
            List<String> bunkers = bunkerName.split(',');
            dynamicQuery += 'AND bunker__r.name IN :bunkers';
        }
        criaturasToReturn = Database.query(dynamicQuery);

        List<Humano> humanos = new List<Humano>();

        for (Criatura__c cri : criaturasToReturn) {
            Bunker bunker = new Bunker(cri.Bunker__r.Name);
            Humano hum = new Humano(cri.name, cri.id, String.valueOf(cri.idade__c), bunker);

            humanos.add(hum);
        }

        HumanosResponse humanosResponse = new HumanosResponse(humanos, humanos.size());

        return humanosResponse;
    }

    global class HumanosResponse {
        List<Humano> humanos;
        Integer total;
        public HumanosResponse(List<Humano> humanos, Integer total) {
            this.humanos = humanos;
            this.total = total;
        }
    }

    global class Humano {
        String nome;
        String idade;
        String id;
        Bunker bunker;
        public Humano(String nome, String idade, String id, Bunker bunker) {
            this.nome = nome;
            this.idade = idade;
            this.id = id;
            this.bunker = bunker;
        }
    }

    global class Bunker {
        String nome;
        public Bunker(String nome) {
            this.nome = nome;
        }
    }
}
