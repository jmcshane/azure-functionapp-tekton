az login --service-principal -u ${USERNAME} -p ${PASSWORD} --tenant ${TENANT}
func azure functionapp publish ${FUNCTION_NAME} --javascript