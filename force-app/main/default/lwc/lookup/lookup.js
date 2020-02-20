import {
    LightningElement,
    api,
    track
} from "lwc";
import getRecords from "@salesforce/apex/LookupController.getRecords";

export default class Lookup extends LightningElement {

    // public properties
    @api disabled;
    @api helptext;
    @api iconName;
    @api label;
    @api objectApiName;
    @api placeholder;
    @api primaryField;
    @api readOnly;
    @api recordLimit;
    @api required;
    @api searchText = "";
    @api secondaryField;
    @api ternaryField;
    @api valid;
    @api value;
    @api variant;

    // private properties
    @track errorMessage;
    @track recordArray;
    @track selectedRecord;
    @track showDropdown;
    @track showInvalid;

    //getters
    get isVariantLabelHidden() {

        return this.variant === "label-hidden";
    }

    get classBySelection() {

        let selectionClass = "slds-combobox_container";

        if (this.value) {

            selectionClass += " slds-has-selection";
        }

        return selectionClass;
    }

    get classByVariant() {

        let variantClass = "slds-form-element";

        if (this.variant === "label-inline") {

            variantClass += " slds-form-element_horizontal";
        } else if (this.variant === "label-stacked") {

            variantClass += " slds-form-element_stacked";
        } else if (this.variant === "standard") {

            // do nothing
        }

        if (this.showInvalid) {

            variantClass += " slds-has-error";
        }

        return variantClass;
    }

    // lifecycle hook methods
    connectedCallback() {

        if (!this.disabled) {

            this.disabled = false;
        }

        if (!this.iconName) {

            this.iconName = "standard:user";
        }

        if (!this.label) {

            this.label = "User";
        }

        if (!this.objectApiName) {

            this.objectApiName = "User";
        }

        if (!this.placeholder) {

            this.placeholder = "Search...";
        }

        if (!this.primaryField) {

            this.primaryField = "Name";
        }

        if (!this.readOnly) {

            this.readOnly = false;
        }

        if (!this.recordLimit) {

            this.recordLimit = "10";
        }

        if (!this.required) {

            this.required = false;
        }

        if (!this.secondaryField) {

            this.secondaryField = "Email";
        }

        if (!this.ternaryField) {

            this.ternaryField = "";
        }

        if (!this.valid) {

            this.valid = true;
        }

        if (!this.variant) {

            this.variant = "standard";
        }

        if (!this.selectedRecord) {

            this.selectedRecord = {
                "id": "",
                "primaryField": "",
                "secondaryField": ""
            }
        }

        if (!this.showInvalid) {

            this.showInvalid = false;
        }

        if (this.value) {

            let params = this.getBasicParams();
            params.recordId = this.value;

            this.getRecordsFromServer(params, (result) => {

                this.recordArray = result.data;

                if (this.recordArray.length > 0) {

                    this.selectedRecord = this.recordArray[0];
                    this.value = this.selectedRecord.id;
                }

                this.fireRecordSelected();
            });
        }
    }

    // public methods

    @api checkValidity() {

        if (this.required && !this.value) {

            this.valid = false;
            this.errorMessage = "This field is required";
        }

        return this.valid;
    }

    @api reportValidity() {

        let isValid = this.checkValidity();
        if (isValid) {

            this.showInvalid = false;
            this.errorMessage = null;
        } else {

            this.showInvalid = true;
        }

        return isValid;
    }

    @api setCustomValidity(message) {

        this.errorMessage = message;
    }

    // private methods
    fireRecordSelected() {

        let customEvent = new CustomEvent("recordselected", {
            "detail": this.selectedRecord
        });

        this.dispatchEvent(customEvent);
    }

    getBasicParams() {

        return {
            "objectApiName": this.objectApiName,
            "primaryField": this.primaryField,
            "recordLimit": this.recordLimit,
            "secondaryField": this.secondaryField,
            "ternaryField": this.ternaryField
        }
    }

    getRecordsFromServer(params, callbackOnSuccess) {

        getRecords(params).then(result => {

            if (result.isSuccess) {

                callbackOnSuccess(result);
                this.reportValidity();
            } else {

                this.valid = false;
                
                if (result.error) {

                    this.errorMessage = result.error.message;
                } else if (result.message) {

                    this.errorMessage = result.message;
                }

                this.reportValidity();
            }
        }).catch((error) => {

            this.valid = false;
            this.errorMessage = error.body.message;
            this.reportValidity();
        });
    }

    handleOnClickRecord(event) {

        let recordId = event.currentTarget.dataset.recordId;

        this.recordArray.forEach(record => {

            if (record.id === recordId) {

                this.selectedRecord = record;
            }
        });

        this.value = this.selectedRecord.id;
        this.showDropdown = false;

        this.fireRecordSelected();
    }

    handleOnClickRemove() {

        this.reportValidity();

        this.searchText = null;
        this.showDropdown = false;
        this.selectedRecord = null;
        this.value = null;
    }

    handleOnFocus(event) {

        this.searchText = event.target.value;
        this.searchText = this.searchText.trim();

        let params = this.getBasicParams();

        if (this.searchText) {

            params.searchText = this.searchText;
        }

        this.getRecordsFromServer(params, (result) => {

            this.recordArray = result.data;
            this.showDropdown = true;
        });
    }

    handleOnInput(event) {

        this.searchText = event.currentTarget.value;
        this.searchText = this.searchText.trim();

        let params = this.getBasicParams();

        if (!this.searchText) {

            this.getRecordsFromServer(params, (result) => {

                this.recordArray = result.data;
                this.showDropdown = true;
            });
        }

        if (this.searchText.length >= 3) {

            params.searchText = this.searchText;

            this.getRecordsFromServer(params, (result) => {

                this.recordArray = result.data;
                this.showDropdown = true;
            });
        }
    }

    handleOnKeyDown(event) {

        if (event.key === "Escape") {

            this.reportValidity();

            this.showDropdown = false;
            event.currentTarget.blur();
        }
    }
}