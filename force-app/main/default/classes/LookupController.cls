public with sharing class LookupController {

    @AuraEnabled
    public static ResponseWrapper getRecords(
        String objectApiName,
        String primaryField,
        String recordId,
        String recordLimit,
        String searchText,
        String secondaryField,
        String ternaryField
    ) {

        try {

            List<String> recordIdList = new List<String>();

            if (String.isBlank(searchText)) {

                String queryRecent = 'SELECT Id'
                    + ' FROM RecentlyViewed '
                    + ' WHERE Type = :objectApiName '
                    + ' ORDER BY LastViewedDate '
                    + ' LIMIT ' + recordLimit;

                System.debug(queryRecent);
                Map<String, SObject> idToRecordMap = new Map<String, SObject>(Database.query(queryRecent));
                recordIdList.addAll(idToRecordMap.keySet());
            }

            List<String> fieldNameList = new List<String> {
                'Id',
                primaryField,
                secondaryField
            };

            if (String.isNotBlank(ternaryField)) {

                fieldNameList.add(ternaryField);
            }

            String query = 'SELECT ' + String.join(fieldNameList, ',');
            query += ' FROM ' + objectApiName;

            List<String> whereClauseList = new List<String>();

            if (String.isNotBlank(recordId)) {

                whereClauseList.add('Id = \'' + recordId + '\'');
            } 
            
            if (!recordIdList.isEmpty()) {

                whereClauseList.add('Id IN :recordIdList');
            }

            if (String.isNotBlank(searchText)) {

                if (String.isNotBlank(primaryField)) {

                    whereClauseList.add(primaryField + ' LIKE \'%' + searchText + '%\'');
                }

                if (String.isNotBlank(secondaryField)) {

                    whereClauseList.add(secondaryField + ' LIKE \'%' + searchText + '%\'');
                }

                if (String.isNotBlank(ternaryField)) {

                    whereClauseList.add(ternaryField + ' LIKE \'%' + searchText + '%\'');
                }
            }

            if (!whereClauseList.isEmpty()) {

                query += ' WHERE ' + String.join(whereClauseList, ' OR ');
            }

            if (String.isNotBlank(primaryField)) {

                query += ' ORDER BY ' + primaryField + ' ASC';
            }

            if (String.isNotBlank(recordLimit)) {

                query += ' LIMIT ' + recordLimit;
            }

            System.debug(query);

            List<SObject> recordList = Database.query(query);

            List<RecordWrapper> recordWrapperList = new List<RecordWrapper>();
            for (Sobject record : recordList) {

                RecordWrapper recordWrapper = new RecordWrapper();

                recordWrapper.id = record.get('Id');
                recordWrapper.primaryField = record.get(primaryField);
                recordWrapper.secondaryField = record.get(secondaryField);

                if (String.isNotBlank(ternaryField)) {
                
                    recordWrapper.ternaryField = record.get(ternaryField);
                }

                recordWrapperList.add(recordWrapper);
            }

            return new ResponseWrapper(recordWrapperList, null, true, null);
        } catch (Exception e) {

            return new ResponseWrapper(null, getError(e), false, null);
        }
    }

    private static ErrorWrapper getError(Exception e) {

        return new ErrorWrapper(e.getLineNumber(), e.getMessage(), e.getStackTraceString());
    }

    public with sharing class ErrorWrapper {

        @AuraEnabled
        public Integer lineNumber;

        @AuraEnabled
        public String message;

        @AuraEnabled
        public String stackTrace;

        public ErrorWrapper(Integer lineNumber, String message, String stackTrace) {

            this.lineNumber = lineNumber;
            this.message = message;
            this.stackTrace = stackTrace;
        }
    }

    public with sharing class RecordWrapper {

        @AuraEnabled
        public Object id;

        @AuraEnabled
        public Object primaryField;

        @AuraEnabled
        public Object secondaryField;

        @AuraEnabled
        public Object ternaryField;
    }

    public with sharing class ResponseWrapper {

        @AuraEnabled
        public Object data;

        @AuraEnabled
        public ErrorWrapper error;

        @AuraEnabled
        public Boolean isSuccess;

        @AuraEnabled
        public String message;

        public ResponseWrapper(Object data, ErrorWrapper error, Boolean isSuccess, String message) {

            this.data = data;
            this.error = error;
            this.isSuccess = isSuccess;
            this.message = message;
        }
    }
}