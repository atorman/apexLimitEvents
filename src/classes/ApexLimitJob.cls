global class ApexLimitJob implements Schedulable{
 
 // Execute method
    global void execute(SchedulableContext SC) { 
    // Code to be executed when the schedule class wakes up
          for (Integer i = 0; i < 200; i++) {
              List<Account> a = [select id from Account Limit 1];
              System.debug(Limits.getQueries());
              System.debug(Limits.getLimitQueries());
            }
 
    // This section of code will schedule the next execution 10 minutes from now
   
  datetime nextScheduleTime = system.now().addMinutes(10);
      string minute = string.valueof(nextScheduleTime.minute());
      string second = string.valueof(nextScheduleTime.second ());
      string cronvalue = second+' '+minute+' * * * ?' ;
      string jobName = 'ApexLimitJob ' +
  nextScheduleTime.format('hh:mm');
 
    ApexLimitJob p = new ApexLimitJob();
    system.schedule(jobName, cronvalue , p);
 
    // this section of code will abort the current schedule job
    system.abortJob(sc.getTriggerId());
 
   }
 }