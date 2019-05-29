/**
 * Created by Ponomarov Vladyslav on 29.05.2019.
 */

public with sharing class OpportunityLineItemTriggerHandler {
    public static void onAfterInsert(List<OpportunityLineItem> opportunityLineItems){
        OpportunityLineItemProductService opportunityLineItemProductService = new OpportunityLineItemProductService();
        opportunityLineItemProductService.changeProducts(opportunityLineItems);
    }
}