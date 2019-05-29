/**
 * Created by Ponomarov Vladyslav on 24.05.2019.
 */

public with sharing class Selector {
    public static Map<Id, OpportunityLineItem> getOppLineItemsInformation(List<OpportunityLineItem> opportunityLineItems) {
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

    public static Map<Id, Map<Id, PricebookEntry>> getIdPricebookToProductIdWithPricebookEntry(Map<Id, OpportunityLineItem> oppLineItemsInformation) {
        Map<Id, Map<Id, PricebookEntry>> idProductToPricebookIdWithPricebookEntry = new Map<Id, Map<Id, PricebookEntry>>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        List<Id> productsId = new List<Id>();
        List<Id> pricebookIds = new List<Id>();

        for (OpportunityLineItem elem : oppLineItemsInformation.values()) {
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

        for (PricebookEntry elem : pricebookEntries) {
            if (idProductToPricebookIdWithPricebookEntry.containsKey(elem.Product2Id)) {
                if (!isProductHavePricebook(idProductToPricebookIdWithPricebookEntry, elem)) {
                    addPricebookAndPricebookEntryToProduct(idProductToPricebookIdWithPricebookEntry, elem);
                }

            } else {
                addPricebookEntryToProductToPricebookIdWithPricebookEntry(elem, idProductToPricebookIdWithPricebookEntry);
            }
        }
        return idProductToPricebookIdWithPricebookEntry;
    }


    private static void addPricebookEntryToProductToPricebookIdWithPricebookEntry(PricebookEntry elem, Map<Id, Map<Id, PricebookEntry>> idProductToPricebookIdWithPricebookEntry) {
        Map<Id, PricebookEntry> pricebookEntryMap = new Map<Id, PricebookEntry>();
        pricebookEntryMap.put(elem.Pricebook2Id, elem);
        idProductToPricebookIdWithPricebookEntry.put(elem.Product2Id, pricebookEntryMap);
    }

    private static PricebookEntry addPricebookAndPricebookEntryToProduct(Map<Id, Map<Id, PricebookEntry>> idPricebookToProductIdWithPricebookEntry, PricebookEntry elem) {
        return idPricebookToProductIdWithPricebookEntry.get(elem.Product2Id).put(elem.Pricebook2Id, elem);
    }

    private static Boolean isProductHavePricebook(Map<Id, Map<Id, PricebookEntry>> idPricebookToProductIdWithPricebookEntry, PricebookEntry pricebookEntry) {
        return idPricebookToProductIdWithPricebookEntry.get(pricebookEntry.Product2Id).containsKey(pricebookEntry.Pricebook2Id);
    }
}