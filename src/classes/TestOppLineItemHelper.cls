/**
 * Created by Ponomarov Vladyslav on 28.05.2019.
 */


public class TestOppLineItemHelper {

   public static List<Product2> getProducts(Integer quantity) {
        List<Product2> product2s = new List<Product2>();
        for (Integer i =0 ; i < quantity; i++){
                Product2 product = new Product2();
                product.Name = 'Test Product' + i;
                product.IsActive = true;
                product2s.add(product);
        }

        insert product2s;
        return product2s;
    }

   public static List<PricebookEntry> getPricebookEntries(List<Product2> product2s, Pricebook2 pricebook2){
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Product2 elem: product2s){
            PricebookEntry pricebookEntry = new PricebookEntry();
            pricebookEntry.IsActive = true;
            pricebookEntry.Pricebook2Id = pricebook2.Id;
            pricebookEntry.Product2Id = elem.Id;
            pricebookEntry.UnitPrice = 777;
            pricebookEntries.add(pricebookEntry);
        }

       insert pricebookEntries;
        return pricebookEntries;
    }

   public static List<OpportunityLineItem> getOppLineItem(List<PricebookEntry> pricebookEntries, Id opportunityId){
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        for (PricebookEntry elem: pricebookEntries){
            OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
            opportunityLineItem.Product2Id = elem.Product2Id;
            opportunityLineItem.UnitPrice = elem.UnitPrice;
            opportunityLineItem.Quantity = 2;
            opportunityLineItem.OpportunityId = opportunityId;
            opportunityLineItems.add(opportunityLineItem);
        }

       insert opportunityLineItems;
        return opportunityLineItems;
    }

}