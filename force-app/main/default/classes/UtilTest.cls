@isTest
public class UtilTest {
    @isTest
    static void GetRandomItemTest() {
        // preparação de cenário
        List<Criatura__c> creatureList = new List<Criatura__c>();
        for (integer i = 0; i <= 200; i++) {
            creatureList.add(new Criatura__c(name = 'Criatura ' + i));
        }

        //teste
        test.startTest();
        Criatura__c cri = (Criatura__c) Util.GetRandomItem(creatureList);
        test.stopTest();

        //validação do resultado
        Boolean flag = false;
        for (Criatura__c criFor : creatureList) {
            if (criFor.name == cri.name)
                flag = true;
        }
        System.assert(flag, 'O item randomico não existe na lista.');
    }
    @isTest
    static void GetRandomItemTest2() {
        // preparação de cenário
        List<Criatura__c> creatureList = new List<Criatura__c>();

        //teste
        try {
            test.startTest();
            Criatura__c cri = (Criatura__c) Util.GetRandomItem(creatureList);
            test.stopTest();
        } catch (System.Exception e) {
            System.assert(e instanceof Util.EmptyListException, 'Unexpected Exception');
        }
    }
    @isTest
    static void GetRandomItemTest3() {
        // preparação de cenário
        List<Criatura__c> creatureList = new List<Criatura__c>();

        //teste

        //validação do resultado
        try {
            test.startTest();
            Criatura__c cri = (Criatura__c) Util.GetRandomItem(null);
            test.stopTest();
        } catch (System.Exception e) {
            System.assert(e instanceof Util.NullParameterException, 'Unexpected Exception');
        }
    }
    @isTest
    static void GetRandomItemTest4() {
        // preparação de cenário
        List<Criatura__c> creatureList = new List<Criatura__c>();
        creatureList.add(new Criatura__c(name = 'Criatura 1'));

        //teste
        test.startTest();
        Criatura__c cri = (Criatura__c) Util.GetRandomItem(creatureList);
        test.stopTest();

        //validação do resultado

        System.assertEquals(cri, creatureList.get(0));
    }
}
