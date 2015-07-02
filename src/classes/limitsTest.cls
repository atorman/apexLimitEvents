/**
 * Copyright (c) 2012, Salesforce.com, Inc.  All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 * 
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 * 
 *   * Neither the name of Salesforce.com nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
// to test: workbench rest - /services/apexrest/limitsTest/tooManyQueries
@RestResource(urlMapping='/limitsTest/*')

global class limitsTest {

@HttpGet
    
    global static void service(){
       RestRequest req = RestContext.request;
       RestResponse res = RestContext.response;
       String uri = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        If (uri=='query'){
            List<Account> ale = 
                [SELECT Id, Name 
                 FROM Account         
                 Limit 100];
            res.responseBody = Blob.valueOf(JSON.serializePretty(ale));
        } else if (uri=='countIds') {
            countId();
            //List<AggregateResult> countId = countId();
            //res.responseBody = Blob.valueOf(JSON.serialize(countId));
        } else if (uri=='count'){
            count();
            //Integer count = count();
            //res.responseBody = Blob.valueOf(JSON.serialize(count));
        } else if (uri=='tooManyScript'){
            tooManyScript();
        } else if (uri=='tooManyQueries'){
            tooManyQueries();
        } else if (uri=='tooManySearches'){
            tooManySearches();
        } else if (uri=='tooMuchHeap'){
            tooMuchHeap();
        } else if (uri=='tooManyDML'){
            tooManyDML();
        } else if (uri=='tooManyDMLRows'){
            tooManyDMLRows();
        } else if (uri=='createAccountRows'){
            createAccountRows(); 
        } else if (uri=='QueriesAndDescribes'){
            QueriesAndDescribes();
        }
          //final catch all
          else {
            System.debug('I got 101 problems but apex rest web services ain\'t one');
            String s = 'I got 101 problems but apex rest web services ain\'t one';
            res.responseBody = Blob.valueOf(s);
          }
    }

    global static List<AggregateResult> countId(){
        List<AggregateResult> countId = [SELECT count(Id) from Account];
        return countId;
    }
    
    global static Integer count(){
        Integer count = [SELECT count() from Account];
        return count;
    }
    
     public static void tooManyScript() {
        for (integer i = 0; i<100002; i++) {
            Math.round(3.4);
            Math.max(2,9);
        }
    }
    
     public static void tooManyQueries() {
          for (Integer i = 0; i < 200; i++) {
              List<Account> a = [select id from Account Limit 1];
              System.debug(Limits.getQueries());
              System.debug(Limits.getLimitQueries());
            }
        }
    
    public static void tooManySearches() {
        for (Integer i = 0; i < 200; i++) {
            List<List<SObject>> searchList = [FIND 'jo' IN ALL FIELDS
            RETURNING Account (Id, Name)];
        }
    }
    
    public static void tooMuchHeap() {
        tooMuchHeap(22);
    }
    public static void tooMuchHeap(Integer bust) {
        String biggun = 'x';
        String biggun2 = 'y';
        String biggun3 = 'z';
        String biggun4 = 'a';
        String biggun5 = 'b';
        for (Integer i = 0; i < bust; i++) {
            biggun = biggun + biggun;
            biggun2 = biggun2 + biggun2;
            biggun3 = biggun3 + biggun3;
            biggun4 = biggun4 + biggun4;
            biggun5 = biggun5 + biggun5;
        }
    Integer x=0;
        for (Integer j = 0; j < 1000; j++) {
            x++;
            x--;
        }
    }
    
    public static void tooManyDML() {
        for (Integer i = 0; i < 200; i++) {
      Account a = new Account();
          a.name = 'busted';
            insert a;
        }
    }
    
    public static void tooManyDMLRows() {
    List<Account> a = [select id, name from Account Limit 10001];
        update a;
    }
    
    public static void createAccountRows() {
        for (Integer i = 0; i < 200; i++) {
            Account a = new Account();
            a.name = 'something';
            insert a;
        }
    }
    
    public static void QueriesAndDescribes() {
        for (Integer i = 0; i < 90; i++) {
            List<Account> a = [select id from Account Limit 1];
            Schema.DescribeFieldResult f = Schema.sObjectType.Account.fields.Name;
            System.debug('DescribeFieldResult'+f);
      System.debug(Limits.getQueries());
          System.debug(Limits.getLimitQueries());            
        }
    }
}