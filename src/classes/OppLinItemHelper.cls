/**
 * Created by Ponomarov Vladyslav on 24.05.2019.
 */

public with sharing class OppLinItemHelper {
    public static List<OpportunityLineItem> getOppLineItemsWithPriceBookByIds(List<OpportunityLineItem> oliId){
        return [Select Id,
                    OpportunityId,
                    Change_Product__c,
                    UnitPrice,
                    Quantity,
                    PricebookEntry.Pricebook2.Id
                    From OpportunityLineItem
                    WHERE Id in: oliId
        ];
    }


    public static List<PricebookEntry> getPricebookIEntries(List<Id> productsId){
        List<PricebookEntry> pricebookEntries = [SELECT Id,
                                                        Name,
                                                        Product2Id,
                                                        Pricebook2Id,
                                                        UnitPrice,
                                                        Pricebook2.IsStandard
                                                        FROM PricebookEntry
                                                        WHERE Product2Id IN :productsId
        ];

        return pricebookEntries;
    }

    public static Map<Id, List<Id>> getProductIdsWithPricebookIds(List<PricebookEntry> pricebookEntries){
        Map<Id, List<Id>> result = new Map<Id, List<Id>>();

        for (PricebookEntry elem: pricebookEntries){
            if(result.containsKey(elem.Product2Id)){
                result.get(elem.Product2Id).add(elem.Pricebook2Id);
            }else{
                result.put(elem.Product2Id, new List<Id>{elem.Pricebook2Id});
            }
        }

        return result;
    }

    public static Id getStandardPricebookId(List<PricebookEntry> pricebookEntries){
        for (PricebookEntry elem: pricebookEntries){
            if (elem.Pricebook2.IsStandard) {
                return elem.Pricebook2.Id;
            }
        }

        return  null;
    }
}