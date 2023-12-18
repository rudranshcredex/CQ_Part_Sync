import { LightningElement } from 'lwc';
import getRecordsMethod from '@salesforce/apex/getRecords.getRecordsMethod';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UtilityButton extends LightningElement {

    handleButton() {
        getRecordsMethod().then(results => {
            console.log('success----->', results);
        })
        .catch(error => {
                console.error('Error---->', error);
            });
    }
}