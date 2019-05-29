/**
 * Created by Ponomarov Vladyslav on 23.05.2019.
 */

trigger OpportunityLineItemTrigger on OpportunityLineItem (after update) {
    if(Trigger.isAfter){
        if (Trigger.isUpdate) {
            OpportunityLineItemTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}