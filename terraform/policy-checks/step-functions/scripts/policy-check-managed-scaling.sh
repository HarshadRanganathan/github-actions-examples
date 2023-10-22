{
  echo "|Result |File |Reason |" 
  echo "|--- |--- |--- |" 
} >> "$GITHUB_STEP_SUMMARY"
echo "result=pass" >> "$GITHUB_OUTPUT"
          
for file in $CHANGED_FILES; do
  if [ "${file: -4}" == ".tpl" ]; then
    if ! grep -q ManagedScalingPolicy "$file"; then
      echo "|👎 |$file | No Managed Scaling defined in template|" >> $GITHUB_STEP_SUMMARY
      echo "result=fail" >> "$GITHUB_OUTPUT"
    else
      echo "|👍  |$file | Managed Scaling defined in template|" >> $GITHUB_STEP_SUMMARY
    fi
  fi
done
          
echo "" >> $GITHUB_STEP_SUMMARY
echo "Please refer our guide on how to add Managed Scaling to your templates: https://" >> $GITHUB_STEP_SUMMARY
          
echo "summary<<EOF"  >> $GITHUB_ENV
cat $GITHUB_STEP_SUMMARY >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV
