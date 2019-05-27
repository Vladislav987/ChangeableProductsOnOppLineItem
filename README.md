# ChangeableProductsOnOppLineItem
<h2>Original requirements</h2>
We would like you to help with a much-needed functionality. Currently we have Opportunity object and related list of Opportunity Line Items. On each Opportunity Line Item, there’s a lookup to a Product object, which we cannot modify. Our sales managers must re-create an Opportunity Line Item each time, they want to change a product on the Opportunity Line Item, which drives them nuts.
Could you please develop something, so that our users don’t need to go over Opportunity Line Item creation process over and over again, each time they need to change a product on Opportunity Line Item?

<br><h2>BA Notes</h2></br>
Hi Developer, this is what I understood from Pam’s requirements:
<ul>
  <li>The Customer use standard object – Opportunity.</li>
  <li>The Customer use standard object – Opportunity Line Item.</li>
  <li>Opportunity Line Item object has a lookup field with relation to Product. Lookup value is immutable.</li>
  <li>The Customer wants be able to modify the value of the lookup field. Users should not be re-creating Opportunity Line Item for this.</li>
</ul>
    
