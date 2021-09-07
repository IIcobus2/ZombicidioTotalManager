global class CureAll implements Schedulable {
    global void execute(SchedulableContext SC) {
        System.Database.executeBatch(new VacinaSim(), 100);
    }
}
// private void execute() {
//     List<Criatura__c> zombieList = [SELECT id FROM Criatura__c WHERE recordtypeID = '0125e000000Rg6aAAC' LIMIT 100];

//     for (Criatura__c zb : zombieList) {
//         if (zombieList.size() == 0)
//             break;
//         zb.RecordTypeId = '0125e000000Rg6VAAS';
//         zb.Data_de_Zumbificacao__c = null;
//         zb.Tipo_do_Zumbi__c = null;
//         zb.Defesa_Criatura__c = 0;
//     }
//     update zombieList;
// }
