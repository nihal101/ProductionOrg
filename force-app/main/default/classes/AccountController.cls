@RestResource(urlMapping='/account/*')
global With Sharing class AccountController {
    
    @HttpGet
    global static void getAccount() {
        Account acc = new Account(Id = '0012w00001XVxm3AAD');
        acc.Name = 'JIRA';
        update acc;
        System.debug('Test1');
    }
    
    @HttpPost
    global static String createAccount() {
        Account acc = new Account();
        acc.Name = 'Postman 123';
        insert acc;
        return acc.Name;
    }
    
    /*@HttpPost
    global static Boolean setAccount() {
        //Account acc = new Account(Id = '0012w00001XVxm3AAD');
       // acc.Name = 'JIRA';
        /*try {
            RestRequest req = RestContext.request;
            String result = req.requestBody.toString();
            Map<String, Object> paresedResponse = (Map<String, Object>)JSON.deserializeUntyped(result);
            if(paresedResponse.get('webhookEvent').toString() == 'comment_created') {
                Map<String, Object> comment = (Map<String, Object>)paresedResponse.get('comment');
                Map<String, Object> issue = (Map<String, Object>)paresedResponse.get('issue');
                createComment(comment, issue);
            }else if(paresedResponse.get('webhookEvent').toString() == 'comment_updated') {
                Map<String, Object> comment = (Map<String, Object>)paresedResponse.get('comment');
                updateComment(comment);
            }else if(paresedResponse.get('webhookEvent').toString() == 'comment_deleted') {
                Map<String, Object> comment = (Map<String, Object>)paresedResponse.get('comment');
                deleteComment(comment);
            }
            else if(paresedResponse.get('webhookEvent').toString() == 'jira:issue_created') {
                Map<String, Object> issue = (Map<String, Object>)paresedResponse.get('issue');
                createIssue(issue);
            }
            else if(paresedResponse.get('webhookEvent').toString() == 'jira:issue_updated') {
                Map<String, Object> issue = (Map<String, Object>)paresedResponse.get('issue');
                updateIssue(issue);
            }
            else if(paresedResponse.get('webhookEvent').toString() == 'jira:issue_deleted') {
                Map<String, Object> issue = (Map<String, Object>)paresedResponse.get('issue');
                deleteIssue(issue);
            }
            acc.Description = result;
        }catch(Exception ex) {
            acc.Description = ex.getMessage() + '  ' + ex.getStackTraceString();
        }*/
        //update acc;
        //RestRequest req = RestContext.request;
        //Account acc = new Account();
        //String result = req.requestBody.toString();
        //acc.Name = 'Postman';
        //acc.Description = result;
        //insert acc;
        //return true;
    //}*/
    
    public static void createComment(Map<String, Object> comment, Map<String, Object> issue) {
        List<Case> casedetails = [SELECT Id, JIRA_Key__c FROM CASE WHERE JIRA_Key__c =: issue.get('key').toString()];
        if(casedetails.size() > 0) {
            Case_Comment__c cm = new Case_Comment__c();
            cm.Comment_Body__c = comment.get('body').toString();
            cm.JIRA_Comment_Id__c = comment.get('id').toString();
            cm.Case__c = casedetails[0].Id;
            RecursionTriggerHelper.isFirstTime = false;
            insert cm;
        }
    }
    
    public static void updateComment(Map<String, Object> comment) {
        List<Case_Comment__c> casecommentdetails = [SELECT Id, JIRA_Comment_Id__c FROM Case_Comment__c WHERE JIRA_Comment_Id__c =: comment.get('id').toString()];
        if(casecommentdetails.size() > 0) {
            casecommentdetails[0].Comment_Body__c = comment.get('body').toString();
            RecursionTriggerHelper.isFirstTime = false;
            update casecommentdetails[0];
        }
    }
    
    public static void deleteComment(Map<String, Object> comment) {
        List<Case_Comment__c> casecommentdetails = [SELECT Id, JIRA_Comment_Id__c FROM Case_Comment__c WHERE JIRA_Comment_Id__c =: comment.get('id').toString()];
        if(casecommentdetails.size() > 0) {
            RecursionTriggerHelper.isFirstTime = false;
            delete casecommentdetails[0];
        }
    }
    
    public static void createIssue(Map<String, Object> issue ) {
        List<Case> casedetails = [SELECT Id, JIRA_Key__c FROM CASE WHERE JIRA_Key__c =: issue.get('key').toString()];
        if(casedetails.size() == 0) {
            Map<String, Object> fields = (Map<String, Object>)issue.get('fields');
            Case c = new Case();
            c.Subject = fields.get('summary').toString();
            c.Description = fields.get('description') != null && fields.get('description') != '' ? fields.get('description').toString() : '';
            c.JIRA_Key__c = issue.get('key').toString();
            insert c;
        }
    }
    
    public static void updateIssue(Map<String, Object> issue ) {
        List<Case> casedetails = [SELECT Id, JIRA_Key__c FROM CASE WHERE JIRA_Key__c =: issue.get('key').toString()];
        if(casedetails.size() > 0) { 
            Map<String, Object> fields = (Map<String, Object>)issue.get('fields');
            casedetails[0].Subject = fields.get('summary').toString();
            casedetails[0].Description = fields.get('description').toString();
            update casedetails[0];
        }
    }
    
    public static void deleteIssue(Map<String, Object> issue ) {
        List<Case> casedetails = [SELECT Id, JIRA_Key__c FROM CASE WHERE JIRA_Key__c =: issue.get('key').toString()];
        if(casedetails.size() > 0) { 
            delete casedetails[0];
        }
    }
}
