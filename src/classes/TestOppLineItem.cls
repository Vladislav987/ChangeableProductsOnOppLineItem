/**
 * Created by Ponomarov Vladyslav on 28.05.2019.
 */

@IsTest
private class TestOppLineItem {
    @IsTest(seeAllData = true)
    static void runTest() {
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

        Pricebook2 pricebook2 = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        products = TestOppLineItemHelper.getProducts(5);

        System.debug('PricebookId '+pricebook2);
        System.debug('Products ' + products);

        pricebookEntries = TestOppLineItemHelper.getPricebookEntries(products, pricebook2);

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.CloseDate = Date.today().addMonths(2);
        opportunity.StageName = 'Prospecting';
        opportunity.Pricebook2Id = pricebook2.Id;
        insert opportunity;

        opportunityLineItems = TestOppLineItemHelper.getOppLineItem(pricebookEntries, opportunity.Id);

        Product2 product = new Product2();
        product.Name = 'Test Product';
        product.IsActive = true;
        insert  product;



        Test.startTest();

        // positive variant, Pricebook has all products

        Integer length = products.size()  - 1;
        for (OpportunityLineItem elem: opportunityLineItems){
            elem.Change_Product__c = products.get(length).Id;
        }

        // negative variant, Pricebook hasn`t this product

        opportunityLineItems.get(0).Change_Product__c = product.Id;

        Database.update(opportunityLineItems) ;
        Test.stopTest();

    }
}