import { LightningElement } from 'lwc';
import getRecordsMethod from '@salesforce/apex/getRecords.getRecordsMethod';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UtilityButton extends LightningElement {

    handleButton() {
        getRecordsMethod().then(results => {
            console.log('success----->', results);
            
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Inserted',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            
   
        })
        .catch(error => {
                console.error('Error---->', error);
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Insert Failed',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            });
    }
}