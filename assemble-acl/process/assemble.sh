#!/bin/bash

url="https://github.com/JayWStapleton/pedxing.org"
policyfile="policy.hujson"

header="// This tailnet's ACLs are maintained in $url" 

echo $header > $policyfile
printf "\n{\n" >> $policyfile

for policy in ls *.policy; 
do
cat $policy 2>/dev/null | sed 's/},/}/g;s/}/},/g' >> $policyfile 
done
echo "}" >> $policyfile