Example setup for splitting an ACL file up into sections, then reassembling it with a GitHub Action. 
Each .policy file is a segment of the ACL. The script checks trailing commas, then cats the files together before posting via the API. Optionally, you may use CODEOWNERS to require specific approvers for changes to that file. 
