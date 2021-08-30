public with sharing class Util {
    public Util() {
    }

    public static SObject GetRandomItem(List<SObject> lst) {
        if (lst == null) {
            throw new NullParameterException();
        }
        if (lst.size() == 0) {
            throw new EmptyListException();
        }
        return lst.get(Math.mod(Integer.valueOf(Math.random() * 1000000000), lst.size()));
    }

    public class EmptyListException extends System.Exception {
    }
    public class NullParameterException extends System.Exception {
    }
}
