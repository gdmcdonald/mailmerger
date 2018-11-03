![MailMergeR](MailMergeR.png)

A mail merge script for R, using the [gmailR](https://cran.r-project.org/web/packages/gmailr/index.html) package. 



I was organising a conference and had to send out hundreds of emails to the conference guests with individual details for each of them so I wrote a script. Hopefully it is helpful for you too! (And ideally you're not sending spam everywhere...please don't!)



## How to use it

1. Install gmailR and authenticate with your gmail account (maybe even make a new gmail account for the conference you're organising?)

2. Update 'EmailList.csv' with your list of emails, one column for all of the other possible pieces of information you want to mail merge. E.g. "FirstName" "LastName", "FavouriteColour". No spaces in column names. The demo file looks like this:

   | FirstName | LastName | Email                             | Role                     | DietaryRestriction  | DatesVolunteered |
   | --------- | -------- | --------------------------------- | ------------------------ | ------------------- | ---------------- |
   | Mail      | Merger   | mailmerger.telleveryone@gmail.com | Post Delivery Specialist | Fruitarian          | 10/3/19          |
   | Bob       | Builder  | bob.builder@gmail.com             | Lead Domestic Engineer   | Allergic to pre-fab | 1/4/22           |

3. Update 'TemplateEmail.html' with the template for the email you want to send. Anything you want replaced from the email list, name it the same as the column name above, but with 'replace' infront of it. E.g. replaceFirstName, replaceLastName, replaceFavouriteColour. The demo html file looks like this:
```html
<html>
<img src="https://gdmcdonald.github.io/img/MailMergeR.png" width="500"/>

<p>Dear replaceFirstName,</p>

<p>This is an important email!</p>

<p><b>THANK YOU</b> for reading it!</p>

<p>This email is to provide you with a bit of information.</p>

<p><b>Firstly, your role.</b><br>
  You have volunteered to be a replaceRole, on replaceDatesVolunteered - THANK YOU AGAIN!<br>
  Your Dietary Restrictions are: <b>replaceDietaryRestriction</b>.<br><br><br>

  <a href="https://github.com/gdmcdonald/mailmerger">MailMergeR on GitHub</a>
</p>
```
4. Update 'TemplateSubjectLine.txt' with the subject line. Same replacement rules apply here. The example is:

   ```replaceRole starting on date replaceDatesVolunteered```

5. Run the script 'mailMe.R'. If you'd like to see an example output to check what it looks like, run the function 

   ```r
   saveDemoEmail(contactListWithHtml,1)
   ```

   which will save (in the same folder) an example email which will be sent, so you can look it over to be sure.

6. When you're ready to go, send all the emails by running the function
   ```r
   sendThemAll()
   ```

Voila! All sent.

