trigger EntraNoBunker on Criatura__c(after insert, after update) {
    //Verificar se o bunker da criatura foi adicionado

    List<Criatura__c> CriaturasBunker = new List<Criatura__c>();
    List<Criatura__c> NovasCriaturas = Trigger.new;
    Map<id, Criatura__c> MapaCriaturasAntigas = Trigger.oldMap;

    for (Criatura__c cr : NovasCriaturas) {
        if ((cr.bunker__c != null) && (cr.bunker__c != Trigger.oldMap.get(cr.id).bunker__c)) {
            CriaturasBunker.add(cr);
        }
    }

    //Montar uma lista com os recursos das criaturas

    List<Criatura__c> dadosCri = new List<Criatura__c>();
    List<Recurso_do_Bunker__c> recursosInsert = new List<Recurso_do_Bunker__c>();
    List<Recurso_da_Criatura__c> recursosCriaturaDelete = new List<Recurso_da_Criatura__c>();
    dadosCri = [
        SELECT id, bunker__c, (SELECT id, Quantidade__c, Recurso__c, Recurso__r.id FROM Recursos_da_Criatura__r)
        FROM criatura__c
        WHERE id IN :CriaturasBunker
    ];

    // para cada criatura, verificar se no bunker que está indo não há itensCritura === itensBunker -> se sim: adicionar à quantidade do item id    || Se não: adicionar na lista de recursosBunker
    if (NovasCriaturas[0].Bunker__c != null) {
        List<Recurso_do_Bunker__c> recursosBunker = [
            SELECT Id, Bunker__c, Recurso__r.Name, Quantidade__c
            FROM Recurso_do_Bunker__c
            WHERE Bunker__c = :dadosCri[0].Bunker__c
        ];
        System.debug('recursosBunker::' + recursosBunker);

        Boolean flag = false;
        //Fazer for
        for (Criatura__c cr : dadosCri) {
            for (Recurso_da_Criatura__c rc : cr.Recursos_da_Criatura__r) {
                flag = false;
                for (Recurso_do_Bunker__c rb : recursosBunker) {
                    System.debug(
                        'rc.Recurso__r.id != rb.Recurso__r.id:: ' +
                        rc.Recurso__r.id +
                        ' != ' +
                        rb.Recurso__r.id
                    );
                    if (rc.Recurso__r.id != rb.Recurso__r.id) {
                        flag = true;
                    } else {
                        rb.Quantidade__c += rc.Quantidade__c;
                        flag = false;
                        break;
                    }
                }
                System.debug('>>flag::' + flag);
                if (flag == true) {
                    RecursosInsert.add(
                        new Recurso_do_Bunker__c(
                            Recurso__c = rc.Recurso__c,
                            Quantidade__c = rc.Quantidade__c,
                            bunker__c = cr.bunker__c
                        )
                    );
                    RecursosCriaturaDelete.add(rc);
                } else {
                    RecursosCriaturaDelete.add(rc);
                }
            }
        }
        update recursosBunker;
    }
    insert recursosInsert;
    delete recursosCriaturaDelete;
}
