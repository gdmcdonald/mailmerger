library(gmailr)
library(tidyverse)
library(here)
library(data.table)
library(stringr)

#First you have to set up gmailr to work from your gmail account. Then...

# Load contact list and html template
contactList <- fread(here::here("EmailList.csv"))
html_doc <- read_file(here::here("TemplateEmail.html"))
subject_line <- read_file(here::here("TemplateSubjectLine.txt"))
from_email_address <- "from@email.com"

# Adds columns to 'contactList' with the emplates, after they've been replaced for each person
addTemplateWithReplacements <- function(contactList=contactList,
                                        html_doc=html_doc,
                                        subject_line=subject_line){
  #duplicate contact list with colnames prefixed by "replace"
  contactList2<-contactList
  names(contactList2)<-paste0("replace",names(contactList))
  
  #add the html template
  #replace all the mail merge fields i.e. replaceFirstName - > FirstName
  contactListWithHtml<-contactList %>%
    group_by(Email) %>%    # do the next mutate separately per email
    mutate(my_html_doc = html_doc %>% #add the html 
             str_replace_all(pattern = unlist(contactList2 %>% #make a named vector for str_replace_all
                                                filter(replaceEmail == Email))),
           my_subject = subject_line %>% #add the subject line
             str_replace_all(pattern = unlist(contactList2 %>% #make a named vector for str_replace_all
                                                filter(replaceEmail == Email))) #add the subject line
    )%>%
    ungroup()
  
  return(contactListWithHtml)
  
}

# Function to check the template replacements before sending.
saveDemoEmail <- function(contactListWithHtml=contactListWithHtml,
                          which_one = 1){
  
  email_content<-contactListWithHtml$my_html_doc[which_one]
  fwrite(list(email_content),
         file = here::here(paste0("example_content_",which_one,".html")),
         quote = F)
  
  email_subject<-contactListWithHtml$my_subject[which_one]
  fwrite(list(email_subject),file = here::here(paste0("example_subject_",which_one,".txt")),
         quote = F)
}

# Function to send the all the emails
sendThemAll <- function(contacts_with_html=contactListWithHtml,
                        from_address=from_email_address){
  for ( i in 1:nrow(contacts_with_html) ) {
    mime() %>%
      subject(contacts_with_html[i,"my_subject"][[1]]) %>%
      to(contacts_with_html[i,"Email"][[1]]) %>%
      from(from_address) %>%
      html_body(contacts_with_html[i,"my_html_doc"][[1]])%>%
      send_message()
  }
}


contactListWithHtml <- addTemplateWithReplacements(contactList=contactList,
                                                   html_doc=html_doc,
                                                   subject_line=subject_line)

saveDemoEmail(contactListWithHtml,1)

sendThemAll()

#This bit sends all the emails



