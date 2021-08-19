public class Zumbificacao {
	@InvocableMethod (label='Transforma Zumbi')

	public Static void zumbificar(List<id> ids){ 
        List<Criatura__c> criList = [SELECT id, Bunker__r.name, bunker__c, (SELECT id from Recursos_da_Criatura__r) FROM Criatura__c WHERE id in :ids];
        List<Recurso_da_Criatura__c> rcDeleteList = new List<Recurso_da_Criatura__c>();
        for(Criatura__c cr : criList){
            String tipoZumbi = '';
            integer rand = Math.mod(Integer.valueof(Math.random()*100000),100);
            if(rand < 50)
            {
                tipoZumbi = 'Lento';
            }
            else if (rand < 80){
                tipoZumbi = 'Rápido';
            }
            else
            {
                tipoZumbi = 'Gordo';
            }
            cr.Tipo_do_Zumbi__c = tipoZumbi;
            if(cr.Recursos_da_Criatura__r != null){
            	rcDeleteList.addAll(cr.Recursos_da_Criatura__r);
                
            }
        }
        update criList;
        delete rcDeleteList;
    }
    
}