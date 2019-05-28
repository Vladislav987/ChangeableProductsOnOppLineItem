/**
 * Created by Ponomarov Vladyslav on 23.05.2019.
 */


public with sharing class OppLinItemHandler {
    public static  void onAfterInsert(List<OpportunityLineItem> opportunityLineItems){
        List<OpportunityLineItem> sortedOppLinItem = new List<OpportunityLineItem>();
        Map<Id, OpportunityLineItem> oppLineItemsInformation = new Map<Id, OpportunityLineItem>();
        Map<Id, Map<Id, PricebookEntry>>  idPricebookToProductIdWithPricebookEntry = new Map<Id, Map<Id,PricebookEntry>>();
        List<OpportunityLineItem> oppLineItemForInsert = new List<OpportunityLineItem>();


        for(OpportunityLineItem  elem: opportunityLineItems){
            if (elem.Change_Product__c != elem.Product2Id && elem.Change_Product__c != null) {
                sortedOppLinItem.add(elem);
            }
        }

        oppLineItemsInformation = OppLinItemHelper.getOppLineItemsInformation(sortedOppLinItem);
        idPricebookToProductIdWithPricebookEntry = OppLinItemHelper.getIdPricebookToProductIdWithPricebookEntry(oppLineItemsInformation);


        for (OpportunityLineItem oppLineItem : oppLineItemsInformation.values()){
            if(idPricebookToProductIdWithPricebookEntry.containsKey(oppLineItem.Change_Product__c)){

                if (idPricebookToProductIdWithPricebookEntry.get(oppLineItem.Change_Product__c).containsKey(oppLineItem.PricebookEntry.Pricebook2Id)) {
                    PricebookEntry pricebookEntry = idPricebookToProductIdWithPricebookEntry.get(oppLineItem.Change_Product__c).get(oppLineItem.PricebookEntry.Pricebook2Id);
                    OpportunityLineItem newOli = createOppLineItem(oppLineItem, pricebookEntry);
                    oppLineItemForInsert.add(newOli);

                }else {
                    Trigger.new[0].addError('You can`t chose this Product because it isn`t in this Opportunity Pricebook');
                    oppLineItemsInformation.remove(oppLineItem.Change_Product__c);
                }

            }else{

                Trigger.new[0].addError('You can`t chose this Product because it isn`t in this Opportunity Pricebook');
                oppLineItemsInformation.remove(oppLineItem.Change_Product__c);

            }
        }


        if (!oppLineItemForInsert.isEmpty()) {
            delete oppLineItemsInformation.values();
            insert oppLineItemForInsert;
        }
    }

    private static OpportunityLineItem createOppLineItem(OpportunityLineItem oppLineItem, PricebookEntry pricebookEntry) {
        OpportunityLineItem newOli = new OpportunityLineItem();
        newOli.Product2Id = oppLineItem.Change_Product__c;
        newOli.Quantity = oppLineItem.Quantity;
        newOli.UnitPrice = pricebookEntry.UnitPrice;
        newOli.OpportunityId = oppLineItem.OpportunityId;
        return newOli;
    }
}