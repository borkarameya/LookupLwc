@IsTest
public with sharing class LookupControllerTest {

    @TestSetup
    static void makeData(){

        Contact contact = new Contact(
            Email = 'test@example.com',
            LastName = 'test contact',
            Phone = '1123581321'
        );

        insert contact;
    }

    @IsTest
    static void getRecordsTestRecent() {

        Test.startTest();

        LookupController.ResponseWrapper response = LookupController.getRecords(
            'Contact', // objectApiName
            'Name', // primaryField
            '', // recordId
            '10', // recordLimit
            '', // searchText
            'Email', // secondaryField
            'Phone' // ternaryField
        );

        Test.stopTest();

        System.assertEquals(response.isSuccess, true);
    }

    @IsTest
    static void getRecordsTestGetContactBySearchText() {

        Test.startTest();

        LookupController.ResponseWrapper response = LookupController.getRecords(
            'Contact', // objectApiName
            'Name', // primaryField
            '', // recordId
            '10', // recordLimit
            'test contact', // searchText
            'Email', // secondaryField
            'Phone'// ternaryField
        );

        Test.stopTest();

        List<Object> recordList = (List<Object>) response.data;
        System.assertEquals(1, recordList.size());
    }

    @IsTest
    static void getRecordsTestGetContactById() {

        Contact contact = [
            SELECT Id
            FROM Contact
            LIMIT 1
        ];

        Test.startTest();

        LookupController.ResponseWrapper response = LookupController.getRecords(
            'Contact', // objectApiName
            'Name', // primaryField
            contact.Id, // recordId
            '10', // recordLimit
            '', // searchText
            'Email', // secondaryField
            'Phone'// ternaryField
        );

        Test.stopTest();

        List<Object> recordList = (List<Object>) response.data;
        System.assertEquals(1, recordList.size());
    }

    @IsTest
    static void getRecordsTestGetError() {

        Test.startTest();

        LookupController.ResponseWrapper response = LookupController.getRecords(
            'fake object', // objectApiName
            'Name', // primaryField
            '', // recordId
            '10', // recordLimit
            '', // searchText
            'Email', // secondaryField
            'Phone'// ternaryField
        );

        Test.stopTest();

        System.assertEquals(false, response.isSuccess);
    }
}
