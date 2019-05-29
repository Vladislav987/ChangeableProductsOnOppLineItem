/**
 * Created by Ponomarov Vladyslav on 23.05.2019.
 */


public with sharing class OpportunityLineItemProductService {
    public void changeProducts(List<OpportunityLineItem> opportunityLineItems) {
        List<OpportunityLineItem> sortedOppLinItem = new List<OpportunityLineItem>();
        Map<Id, OpportunityLineItem> oppLineItemsInformation = new Map<Id, OpportunityLineItem>();
        Map<Id, Map<Id, PricebookEntry>> idPricebookToProductIdWithPricebookEntry = new Map<Id, Map<Id, PricebookEntry>>();
        List<OpportunityLineItem> oppLineItemForInsert = new List<OpportunityLineItem>();

        for (OpportunityLineItem elem : opportunityLineItems) {
            if (isChoseAnotherProduct(elem)) {
                sortedOppLinItem.add(elem);
            }
        }

        oppLineItemsInformation = Selector.getOppLineItemsInformation(sortedOppLinItem);
        idPricebookToProductIdWithPricebookEntry = Selector.getIdPricebookToProductIdWithPricebookEntry(oppLineItemsInformation);


        for (OpportunityLineItem oppLineItem : oppLineItemsInformation.values()) {
            if (idPricebookToProductIdWithPricebookEntry.containsKey(oppLineItem.Change_Product__c)) {

                if (ispProductInOpportunityLineItemPricebook(idPricebookToProductIdWithPricebookEntry, oppLineItem)) {
                    PricebookEntry pricebookEntry = idPricebookToProductIdWithPricebookEntry.get(oppLineItem.Change_Product__c).get(oppLineItem.PricebookEntry.Pricebook2Id);
                    OpportunityLineItem oli = createOppLineItem(oppLineItem, pricebookEntry);
                    oppLineItemForInsert.add(oli);

                } else {
                    throwUsersErrormessage();
                }
            } else {
                throwUsersErrormessage();
            }
        }

        if (!oppLineItemForInsert.isEmpty()) {
            delete oppLineItemsInformation.values();
            insert oppLineItemForInsert;

        }
    }

    private void throwUsersErrormessage() {
        Trigger.new[0].addError('You cann`t chose this Product because It isn`t in Pricebook');
    }

    private Boolean ispProductInOpportunityLineItemPricebook(Map<Id, Map<Id, PricebookEntry>> idPricebookToProductIdWithPricebookEntry, OpportunityLineItem oppLineItem) {
        return idPricebookToProductIdWithPricebookEntry.get(oppLineItem.Change_Product__c).containsKey(oppLineItem.PricebookEntry.Pricebook2Id);
    }

    private Boolean isChoseAnotherProduct(OpportunityLineItem elem) {
        return elem.Change_Product__c != elem.Product2Id && elem.Change_Product__c != null;
    }

    private static OpportunityLineItem createOppLineItem(OpportunityLineItem oppLineItem, PricebookEntry pricebookEntry) {
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Product2Id = oppLineItem.Change_Product__c;
        oli.Quantity = oppLineItem.Quantity;
        oli.UnitPrice = pricebookEntry.UnitPrice;
        oli.OpportunityId = oppLineItem.OpportunityId;
        return oli;
    }
}