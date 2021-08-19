global class ContagionSchedulable implements Schedulable {
    global void execute(SchedulableContext SC) {
        this.contagiar(); 
    }
    
    private void contagiar(){
        List<Criatura__c> humanList = [SELECT id, (SELECT id, Acrescimo_de_Defesa__c FROM Recursos_da_Criatura__r), Bunker__c, Bunker__r.Defesa_do_Bunker__c FROM Criatura__c WHERE recordtypeId = '0125e000000Rg6VAAS'];
        List<Criatura__c> zombieList = [SELECT id FROM Criatura__c where recordtypeId = '0125e000000Rg6aAAC'];
        
        Decimal defesa = 0;
        
        for(Criatura__c zb : zombieList){
            if(humanList.size() == 0) break;
            Criatura__c hmn1 = humanList.get(Math.mod(Integer.valueOf(Math.random()*1000), humanList.size()));
            
            // Verificar se humano está em um bunker - check
            if(hmn1.Bunker__c != NULL){
                defesa += hmn1.Bunker__r.Defesa_do_Bunker__c;
            }
            // Verificar se humano possui recursos - check
            if(hmn1.Recursos_da_Criatura__r != NULL){
                for(Recurso_da_Criatura__c rc : hmn1.Recursos_da_Criatura__r){
                    defesa += rc.Acrescimo_de_Defesa__c;
                }
            }
            // Verificar defesaHumano < DiceRoll
            Integer DiceRoll = Math.mod(Integer.valueof(Math.random()*100000),100)+1;
            if(defesa < DiceRoll){
                hmn1.recordtypeId = '0125e000000Rg6aAAC';
            	hmn1.Data_de_Zumbificacao__c = Date.today();
            }
            defesa = 0;
            
            
            Criatura__c hmn2 = humanList.get(Math.mod(Integer.valueOf(Math.random()*1000), humanList.size()));
            // Verificar se humano está em um bunker - check
            if(hmn1.Bunker__c != NULL){
                defesa += hmn1.Bunker__r.Defesa_do_Bunker__c;
            }
            // Verificar se humano possui recursos - check
            if(hmn1.Recursos_da_Criatura__r != NULL){
                for(Recurso_da_Criatura__c rc : hmn1.Recursos_da_Criatura__r){
                    defesa += rc.Acrescimo_de_Defesa__c;
                }
            }
            // Verificar defesaHumano < DiceRoll
            if(defesa < DiceRoll){
                hmn2.recordtypeId = '0125e000000Rg6aAAC';
                hmn2.Data_de_Zumbificacao__c = Date.today();
            }
        }
        update humanList;
            
        
    }
}