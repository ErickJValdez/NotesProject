public without sharing class NoteAppController {
    
    public Account acc {get; set;}
    public List<Contact> conts;
    public String key {get;set;}
    public set<Id> listOfParentIds;
    public List<Note> notes{get; set;}
    
    public List<Note> tempNotes{get; set;}
    

    public Integer count {get;set;}
    
    public Integer index = 10;
    public Integer start = 0;
    public Integer recordPerPages = 10;
    
    public Boolean nextBool {get;set;}
    public Boolean prevBool {get;set;}
    
    public Boolean goToPdf {get;set;}

    
    public Integer numOfPages {get;set;}
    public Integer actualPage {get;set;}
    
    public NoteAppController()
    {
        acc = new Account() ;
        conts = new List<Contact>();
        listOfParentIds = new set<Id>();
        notes = new List<Note>();
        tempNotes = new List<Note>();
        count = 0;
        numOfPages = 0;
        actualPage = 0;
        nextBool = true;
        prevBool = true;
        goToPdf = true;
    }
    
    
    
    public PageReference searchNow()
    {   
        if(key != '')
        {
            try {
                acc = [SELECT Id, Name FROM Account WHERE Name like :(key+'%') LIMIT 1];
            } catch(Exception e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
            if(acc!=null){
                listOfParentIds.add(acc.Id);
                try {
                    conts = [SELECT Id, Name FROM Contact WHERE AccountId =: acc.Id];
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
                
                count= notes.size();
                if(count>0){
                    notesToShow();
                    numberOfPages();
                    goToPdf = false;
                    actualPage++;
                }
                
                if(count > index) { 
                    nextBool = false;
                    prevBool = true;
                } else {
                    nextBool = true;
                    prevBool = true;
                }
            }
        }
        else
        {
            notes = null;
        }
        return null ;
    }
    
    public PageReference pdfPage() {
        PageReference p = new PageReference('https://theksquaregroup-5d-dev-ed--c.vf.force.com/apex/NotePdfApp?core.apexpages.request.devconsole=1&id='+acc.Id);
        p.setRedirect(true);
        return p; 
    }
    
    public void notesToShow() {
        if(!tempNotes.isEmpty()){
            tempNotes.clear();
        }
        
        for(Integer i = start; i < index; i++) {
            if(count == i) 
                break;
            
            tempNotes.add(notes.get(i));
        }
    }
    
     public void numberOfPages() {
        
       Double temp = Math.ceil(count/recordPerPages);
       Double temp2 = Math.mod(count, recordPerPages);
         
         if(temp2>1)
             temp++;
         
       numOfPages= (Integer)temp;
    }
    
      public void next()
    {
        actualPage++;
        index = index + 10;
        start = start + 10;
        tempNotes.clear();
        if(index > count)
        {
            index = Math.Mod(count,10) + start;
            nextBool = true;
            prevBool = false;
            notesToShow();   
            index = start + 10;   
        }
        else
        {
            notesToShow();   
            prevBool = false;
        }  
    }
   
    public void previous()
    {
        actualPage--;
        if(start > 10)
        {   
            index = index - 10;
            start = start - 10;
            notesToShow();   
            prevBool = false;
            nextBool = false;
        }   
        else
        {
            index = index - 10;
            start = start - 10;
            notesToShow();
            prevBool = true;
            nextBool = false;       
        }  
    }
}