/**
 * Created by Ponomarov Vladyslav on 24.05.2019.
 */

public with sharing class OppLinItemHelper {
    public static Map<Id, OpportunityLineItem> getOppLineItemsInformation(List<OpportunityLineItem> opportunityLineItems){
        return new Map<Id, OpportunityLineItem>([SELECT Id,
                                                        Name,
                                                        Change_Product__c,
                                                        Product2Id,
                                                        PricebookEntry.Pricebook2Id,
                                                        Quantity,
                                                        OpportunityId
                                                    FROM OpportunityLineItem
                                                    WHERE Id IN: opportunityLineItems
        ]);
    }

    public static Map<Id, Map<Id, PricebookEntry>> getIdPricebookToProductIdWithPricebookEntry(Map<Id, OpportunityLineItem> oppLineItemsInformation){
        List<Id> productsId = new List<Id>();
        List<Id> pricebookIds = new List<Id>();
        Map<Id, Map<Id, PricebookEntry>> idPricebookToProductIdWithPricebookEntry = new Map<Id, Map<Id, PricebookEntry>>();
        List<PricebookEntry> pricebookEntries = new  List<PricebookEntry>();

        for(OpportunityLineItem elem: oppLineItemsInformation.values()){
            productsId.add(elem.Change_Product__c);
            pricebookIds.add(elem.PricebookEntry.Pricebook2Id);
        }

        pricebookEntries = [SELECT Id,
                            Product2Id,
                            Pricebook2Id,
                            UnitPrice
                            FROM PricebookEntry
                            WHERE Product2Id IN: productsId
                            AND Pricebook2Id IN:pricebookIds
        ];

        for (PricebookEntry elem: pricebookEntries){
            if (idPricebookToProductIdWithPricebookEntry.containsKey(elem.Product2Id)) {
                if (!idPricebookToProductIdWithPricebookEntry.get(elem.Product2Id).containsKey(elem.Pricebook2Id)) {
                    idPricebookToProductIdWithPricebookEntry.get(elem.Product2Id).put(elem.Pricebook2Id, elem);
                }

            }else {
                Map<Id, PricebookEntry> pricebookEntryMap = new Map<Id, PricebookEntry>();
                pricebookEntryMap.put(elem.Pricebook2Id, elem);
                idPricebookToProductIdWithPricebookEntry.put(elem.Product2Id, pricebookEntryMap);
            }
        }
        return idPricebookToProductIdWithPricebookEntry;
    }
}