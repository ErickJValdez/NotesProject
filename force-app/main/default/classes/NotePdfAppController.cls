public without sharing class NotePdfAppController {
    
    public List<Contact> conts;
    public Account acc {get; set;}
    public Id accId {get;set;}
    public set<Id> listOfParentIds;
    public List<Note> notes{get; set;}  
    
    public NotePdfAppController()
    {
        accId= System.currentPageReference().getParameters().get('id');
        acc = new Account() ;
        conts = new List<Contact>();
        listOfParentIds = new set<Id>();
        notes = new List<Note>();
    }
    
    public List<Note> getListNotes()
    {   
        if(accId != Null)
        {            
            listOfParentIds.add(accId);
            
            try {
                acc = [SELECT Id, Name FROM Account WHERE Id =:accId LIMIT 1];
            } catch(Exception e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            try {
                conts = [SELECT Id, Name FROM Contact WHERE AccountId =: accId];
            }
            catch (Exception e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        
        if(!conts.isEmpty()){
            for(Contact c: conts){
                listOfParentIds.add(c.Id);
            }            
        }
        if(!listOfParentIds.isEmpty()){
            try {
                notes = [SELECT Id, Parent.type, Title, Body, Owner.name FROM Note WHERE ParentId IN:listOfParentIds];
            }
            catch (Exception e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        else
        {
            notes = null;
        }
        return notes;
    }
    
}