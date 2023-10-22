{
  echo "|Result |File |Reason |" 
  echo "|--- |--- |--- |" 
} >> "$GITHUB_STEP_SUMMARY"
echo "result=pass" >> "$GITHUB_OUTPUT"
          
for file in $CHANGED_FILES; do
  if [ "${file: -4}" == ".tpl" ]; then
    if ! grep -q emr-$TARGET_RELEASE_LABEL "$file"; then
      echo "|👎 |$file | Not using EMR release label $TARGET_RELEASE_LABEL |" >> $GITHUB_STEP_SUMMARY
      echo "result=fail" >> "$GITHUB_OUTPUT"
    else
      echo "|👍  |$file | Using EMR release label $TARGET_RELEASE_LABEL |" >> $GITHUB_STEP_SUMMARY
    fi
  fi
done
          
echo "" >> $GITHUB_STEP_SUMMARY
echo "Update your template to use \"ReleaseLabel\": \"emr-$TARGET_RELEASE_LABEL\"" >> $GITHUB_STEP_SUMMARY
          
echo "summary<<EOF"  >> $GITHUB_ENV
cat $GITHUB_STEP_SUMMARY >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV
