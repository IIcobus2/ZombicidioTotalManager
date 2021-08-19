public class CureAll {

    private void execute(){
    
        List<Criatura__c> zombieList = [SELECT id  FROM Criatura__c WHERE recordtypeID = '0125e000000Rg6aAAC'];
        
        for(Criatura__c zb : zombieList){
            if(zombieList.size() == zombieList.size()/2) break;
            zb.RecordTypeId  = '0125e000000Rg6VAAS';
            zb.Data_de_Zumbificacao__c = NULL;
            zb.Tipo_do_Zumbi__c = NULL;
            
            
        }
        update zombieList;
    }
	
    

}