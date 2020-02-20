# LookupLwc

This component is a basic lookup LWC that is reusable within Salesforce.

**Basic example:**

```<lookup></lookup>```

When no attributes are provided, it works as a lookup component for the User object.

## **Attributes:**

- ```disabled```
  - Specifies whether the component is disabled or not.
  - **Data type:** boolean
  - **Default value:** false

- ```helptext```
  - Displays a helptext icon which when hovered upon, will display the helptext message.
  - **Data type:** String
  - **Default value:** —

- ```icon-name```
  - Specifies which icon to use for the records in the dropdown. The icon names are based on the ones provided in Salesforce Lightning Design System (SLDS).
  - **Data type:** String
  - **Default value:** standard:user

- ```label```
  - Specifies the label to use for the lookup component.
  - **Data type:** String
  - **Default value:** User

- ```object-api-name```
  - Specifies the API name of the object that is to be lookup upon.
  - **Data type:** String
  - **Default value:** User

- ```placeholder```
  - Specifies the placeholder text that will be displayed when there is no value typed in the component.
  - **Data type:** String
  - **Default value:** Search...

- ```primary-field```
  - Specifies the primary field to use to search and display the records.
  - **Data type:** String
  - **Default value:** Name

- ```read-only```
  - Specifies whether the component is in readonly mode or not.
  - Data type: Boolean
  - Default value: false

- ```record-limit```
  - Specifies the maximum number of records to display in the drop-down.
  - **Data type:** Integer
  - **Default value:** 10

- ```required```
  - Specifies whether a value is required in the field.
  - **Data type:** Boolean
  - **Default value:** false

- ```search-text```
  - Specifies the default search text.
  - **Data type:** String
  - **Default value:** —

- ```secondary-field```
  - Specifies the secondary field that is to be searched and displayed.
  - **Data type:** String
  - **Default value:** Email

- ```ternary-field```
  - Specifies the ternary field that is to be searched and displayed.
  - **Data type:** String
  - **Default value:** —

- ```valid```
  - Specifies whether the input is valid or not.
  - **Data type:** Boolean
  - **Default value:** true

- ```value```
  - Specifies the default record that is be populated while loading.
  - **Data type:** String (Id)
  - **Default value:** —

- ```variant```
  - Specifies the style in which the label is displayed.
  - **Data type:** String
  - **Default value:** standard
  - **Accepted values:** ```label-hidden```, ```label-inline```, ```label-stacked```, ```standard```
  
## Methods
  
- ```checkValidity()```
  - Checks if the input is valid.
    
- ```reportValidity()```
  - Displays the error messages and returns false if the input is invalid. If the input is valid, ```reportValidity()``` clears displayed error messages and returns true.
    
- ```setCustomValidity(message)```
  - Sets a custom error message to be displayed when a form is submitted.
  - ```message```: The string that describes the error. If message is an empty string, the error message is reset.
