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
global with sharing class ApexLimitEventsController {
    
   public List<ApexLimitEvent> ale{get;set;}
    
   // used for the last 10 apex method invocations
    public ApexLimitEventsController() {
        ale = [SELECT EntryPointId,EntryPointName,EntryPointType,EventDate,ExecutionIdentifier,Id,LimitType,LimitValue,NamespacePrefix,UserId,Username 
               FROM ApexLimitEvent 
               WHERE EventDate > Yesterday
               LIMIT 10
               ];
   }
  
   // used for the NumDistinctApexTxs MetricType  
   @RemoteAction   
    global static PlatformEventMetrics[] loadNumDistinctApexTxs() {
        return [SELECT MetricDate, MetricValue FROM PlatformEventMetrics
            WHERE MetricType='NumDistinctApexTxs'
            AND MetricDate = Last_n_Days:7
            ];
    }  
    
    // used for the NumDistinctApexTxWithLimitsExceeding60 MetricType  
   @RemoteAction   
    global static PlatformEventMetrics[] loadNumDistinctApexTxWithLimitsExceeding60() {
        return [SELECT MetricDate, MetricValue FROM PlatformEventMetrics
            WHERE MetricType='NumDistinctApexTxWithLimitsExceeding60'
            AND MetricDate = Last_n_Days:7
            ];
    }
    
    // used for the NumDistinctApexTxLimitsExceeding60ByEntryPointName MetricType 
    @RemoteAction   
    global static PlatformEventMetrics[] loadNumDistinctApexTxWithLimitsExceeding60ByEntryPointName() {
        return [SELECT MetricDate, MetricValue, AggregationFieldValue FROM PlatformEventMetrics
            WHERE MetricType='NumDistinctApexTxLimitsExceeding60ByEntryPointName'
            AND MetricDate = Last_n_Days:7
            ];
    }
    
    // used for the AvgLimitValueByEntryPointName MetricType 
    @RemoteAction   
    global static PlatformEventMetrics[] loadAvgLimitValueByEntryPointName() {
        return [SELECT MetricDate, MetricValue, AggregationFieldValue FROM PlatformEventMetrics
            WHERE MetricType='AvgLimitValueByEntryPointName'
            AND MetricDate = Last_n_Days:7
            ];
    }
    
    // used for the NumDistinctApexTxLimitsExceeding60ByLimitType  MetricType 
    @RemoteAction   
    global static PlatformEventMetrics[] loadNumDistinctApexTxLimitsExceeding60ByLimitType () {
        return [SELECT MetricDate, MetricValue, AggregationFieldValue FROM PlatformEventMetrics
            WHERE MetricDate = Last_n_Days:7 
            AND MetricType = 'NumDistinctApexTxLimitsExceeding60ByLimitType' 
            ];
    }
    // used for the AvgLimitValueByLimitType  MetricType 
    @RemoteAction   
    global static PlatformEventMetrics[] loadAvgLimitValueByLimitType () {
        return [SELECT MetricDate, MetricValue, AggregationFieldValue FROM PlatformEventMetrics
            WHERE MetricDate = Last_n_Days:7 
            AND MetricType = 'AvgLimitValueByLimitType' 
            ];
    }
}