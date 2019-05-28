/**
 * Created by Ponomarov Vladyslav on 23.05.2019.
 */


public with sharing class OppLinItemHandler {
    public static  void onAfterInsert(List<OpportunityLineItem> opportunityLineItems){
        //Test new Branch
        List<OpportunityLineItem> sortedOppLinItem = new List<OpportunityLineItem>();
        Map<Id, List<Id>> productsIdWithPricebookIds = new Map<Id, List<Id>>();
        List<PricebookEntry>  pricebookEntries = new List<PricebookEntry>();
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLineItemForInsert = new List<OpportunityLineItem>();
        List<PricebookEntry> pricebookEntriesForInsert =  new List<PricebookEntry>();
        List<Id> productsId = new List<Id>();
        Id standardPricebookId;

        for(OpportunityLineItem  elem: opportunityLineItems){
            if (elem.Change_Product__c != elem.Product2Id && elem.Change_Product__c != null) {
                sortedOppLinItem.add(elem);
                productsId.add(elem.Change_Product__c);
                productsId.add(elem.Product2Id);

            }
        }

        pricebookEntries = OppLinItemHelper.getPricebookIEntries(productsId);
        oppLineItems = OppLinItemHelper.getOppLineItemsWithPriceBookByIds(sortedOppLinItem);
        productsIdWithPricebookIds = OppLinItemHelper.getProductIdsWithPricebookIds(pricebookEntries);
        standardPricebookId = OppLinItemHelper.getStandardPricebookId(pricebookEntries);

        for (OpportunityLineItem oppLineItem : oppLineItems){
            if(productsIdWithPricebookIds.containsKey(oppLineItem.Change_Product__c)){
                if (productsIdWithPricebookIds.get(oppLineItem.Change_Product__c).contains(oppLineItem.PricebookEntry.Pricebook2Id)) {

                    OpportunityLineItem newOli = createOppLineItem(oppLineItem);
                    oppLineItemForInsert.add(newOli);

                }else {
                    PricebookEntry pricebookEntry = createPricebookEntryForProduct(oppLineItem);
                    pricebookEntriesForInsert.add(pricebookEntry);

                    OpportunityLineItem newOli = createOppLineItem(oppLineItem);
                    oppLineItemForInsert.add(newOli);
                }
            }else{
                PricebookEntry standardPricebookEntry = createStandardPricebookEntry(standardPricebookId, oppLineItem);
                pricebookEntriesForInsert.add(standardPricebookEntry);

                PricebookEntry pricebookEntry = createPricebookEntryForProduct(oppLineItem);
                pricebookEntriesForInsert.add(pricebookEntry);

                OpportunityLineItem newOli = createOppLineItem(oppLineItem);
                oppLineItemForInsert.add(newOli);
            }
        }


        if (!oppLineItems.isEmpty()) {
            insert pricebookEntriesForInsert;
            insert oppLineItemForInsert;
            delete oppLineItems;
        }



    }

    private static PricebookEntry createStandardPricebookEntry(Id standardPricebookId, OpportunityLineItem oppLineItem) {
        PricebookEntry standardPricebookEntry = new PricebookEntry();
        standardPricebookEntry.Pricebook2Id = standardPricebookId;
        standardPricebookEntry.UnitPrice = oppLineItem.UnitPrice;
        standardPricebookEntry.IsActive = true;
        standardPricebookEntry.Product2Id = oppLineItem.Change_Product__c;
        return standardPricebookEntry;
    }

    private static PricebookEntry createPricebookEntryForProduct(OpportunityLineItem oppLineItem) {
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Product2Id = oppLineItem.Change_Product__c;
        pricebookEntry.Pricebook2Id = oppLineItem.PricebookEntry.Pricebook2Id;
        pricebookEntry.UnitPrice = oppLineItem.UnitPrice;
        pricebookEntry.IsActive = true;
        return pricebookEntry;
    }

    private static OpportunityLineItem createOppLineItem(OpportunityLineItem oppLineItem) {
        OpportunityLineItem newOli = new OpportunityLineItem();
        newOli.Product2Id = oppLineItem.Change_Product__c;
        newOli.Quantity = oppLineItem.Quantity;
        newOli.UnitPrice = oppLineItem.UnitPrice;
        newOli.OpportunityId = oppLineItem.OpportunityId;
        return newOli;
    }
}