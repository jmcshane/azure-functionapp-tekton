az login --service-principal -u ${USERNAME} -p ${PASSWORD} --tenant ${TENANT}
cd app && func azure functionapp publish mcshane-tekton-functionapp-test