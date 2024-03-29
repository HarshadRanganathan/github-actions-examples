{
  echo "!!!!! Do not Copy-Paste values from other templates. Please give correct ownership information for these tags !!!!!"
  echo "|Result |File |Reason |" 
  echo "|--- |--- |--- |" 
} >> "$GITHUB_STEP_SUMMARY"
echo "result=pass" >> "$GITHUB_OUTPUT"
          
for file in $CHANGED_FILES; do
  if [ "${file: -4}" == ".tpl" ]; then
            
    team=$(jq '..|objects|select(.Key? == "Team").Value' $file -r)
    echo "Team=${team}"
    if [ -z "${team}" ]; then
      echo "|👎 |$file | Tag 'Team' is not defined for the EMR job |" >> $GITHUB_STEP_SUMMARY
      echo "result=fail" >> "$GITHUB_OUTPUT"
    else
      if [[ "$team" =~ ^[A-Za-z' ']+$ ]]; then
        echo "|👍  |$file | Tag 'Team' is defined with value as $team|" >> $GITHUB_STEP_SUMMARY
      else
        echo "|👎 |$file | Tag 'Team' with value $team is not valid. Should satisfy constraint: ^[A-Za-z' ']+$" >> $GITHUB_STEP_SUMMARY
        echo "result=fail" >> "$GITHUB_OUTPUT"
      fi
    fi
              
    owner=$(jq '..|objects|select(.Key? == "Owner").Value' $file -r)
    echo "Owner=${owner}"
    if [ -z "${owner}" ]; then
      echo "|👎 |$file | Tag 'Owner' is not defined for the EMR job |" >> $GITHUB_STEP_SUMMARY
      echo "result=fail" >> "$GITHUB_OUTPUT"
    else
      if [[ "$owner" =~ ^[A-Za-z' ']+$ ]]; then
        echo "|👍  |$file | Tag 'Owner' is defined with value as $owner|" >> $GITHUB_STEP_SUMMARY
      else
        echo "|👎 |$file | Tag 'Owner' with value $owner is not valid. Should satisfy constraint: ^[A-Za-z' ']+$" >> $GITHUB_STEP_SUMMARY
        echo "result=fail" >> "$GITHUB_OUTPUT"
      fi
     fi
              
     owner_dl=$(jq '..|objects|select(.Key? == "OwnerDL").Value' $file -r)
     echo "OwnerDL=${owner_dl}"
     if [ -z "${owner_dl}" ]; then
       echo "|👎 |$file | Tag 'OwnerDL' is not defined for the EMR job |" >> $GITHUB_STEP_SUMMARY
       echo "result=fail" >> "$GITHUB_OUTPUT"
     else
      if [[ "$owner_dl" =~ (.+)@(.+) ]]; then
        echo "|👍  |$file | Tag 'OwnerDL' is defined with value as $owner_dl|" >> $GITHUB_STEP_SUMMARY
      else
        echo "|👎 |$file | Tag 'OwnerDL' with value $owner_dl is not valid. Should be an Email/DL address" >> $GITHUB_STEP_SUMMARY
        echo "result=fail" >> "$GITHUB_OUTPUT"
      fi
     fi
              
     appname=$(jq '..|objects|select(.Key? == "AppName").Value' $file)
     echo "AppName=${appname}"
     if [ -z "${appname}" ]; then
       echo "|👎 |$file | Tag 'AppName' is not defined for the EMR job |" >> $GITHUB_STEP_SUMMARY
       echo "result=fail" >> "$GITHUB_OUTPUT"
     else
       if [[ ! $(echo ${APPNAMES[@]} | fgrep -w $appname) ]]; then
         echo "|👎 |$file | Tag 'AppName' with value $appname is not valid. Valid projects are: $APPNAMES. If your project is not listed here, please inform Horus team to have it added. |" >> $GITHUB_STEP_SUMMARY
         echo "result=fail" >> "$GITHUB_OUTPUT"
       else
         echo "|👍  |$file | Tag 'AppName' is defined with value as $appname|" >> $GITHUB_STEP_SUMMARY
       fi
      fi
              
  fi
done
          
echo "" >> $GITHUB_STEP_SUMMARY
echo "Please refer our guide on adding valid tags to your templates: https://" >> $GITHUB_STEP_SUMMARY
          
echo "summary<<EOF"  >> $GITHUB_ENV
cat $GITHUB_STEP_SUMMARY >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV
