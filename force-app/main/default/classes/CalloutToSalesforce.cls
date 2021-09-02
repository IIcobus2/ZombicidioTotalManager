public class CalloutToSalesforce {
    public static final String clientId = '3MVG9cHH2bfKACZbw4FIJzzLXnHIegCG.vdQKV4F68gKpiJKGcOksSLSyuePs1f95X5S2NfF6_T4Bn4bslk2z';
    public static final String clientSecret = '1C1F23E8F6C03CA16A4386E53A15D21CC76E5D0B59C163FBF3093A07FFBB1B5B';
    public static final String username = 'integration@00d5e000002hhkveao.com';
    public static final String password = 'Bootcamp4';
    public static final String url = 'https://login.salesforce.com/services/oauth2/token';

    public static String access_token = '';
    public static String instance_url = '';

    private static void getAuth() {
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();

            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setMethod('POST');
            req.setEndpoint(url);
            req.setBody(
                'grant_type=password' +
                +'&client_id=' +
                clientId +
                '&client_secret=' +
                clientSecret +
                '&username=' +
                username +
                '&password=' +
                password
            );

            System.debug('>> req:: ' + req.getBody());
            HttpResponse response = http.send(req);
            System.debug('response:: ' + response);

            if (response.getStatusCode() == 200) {
                Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                access_token = (String) resMap.get('access_token');
                instance_url = (String) resMap.get('instance_url');
            } else {
                System.debug('Deu ruim:: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Error:: ' + e.getMessage());
        }
    }

    public static ResponseHerois getHeroisBootcamp3() {
        final String endpoint = '/services/apexrest/marvel/availableheroes';
        try {
            getAuth();
            if (!String.isBlank(access_token)) {
                Http http = new Http();
                HttpRequest req = new HttpRequest();

                req.setHeader('Authorization', 'Bearer ' + access_token);
                req.setMethod('GET');
                req.setEndpoint(instance_url + endpoint);

                HttpResponse response = Http.send(req);

                System.debug('>>> RESPONSE:: ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug('Error:: ' + e.getMessage());
        }
    }

    public class ResponseHerois {
        public List<Heroi> herois;
        public Integer total;
    }

    public class Heroi {
        public String nome;
        public String nivel;
        public List<Habilidade> habilidades;
    }

    public class Habilidade {
        public String nome;
        public String nivel;
    }
}