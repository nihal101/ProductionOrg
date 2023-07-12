import { LightningElement, track } from 'lwc';

export default class CalloutInLwc extends LightningElement {
    @track myIp;
    body = '--foo_bar_baz\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n {\r\n"name": "My 123"\r\n}\r\n\r\n--foo_bar_baz\r\nContent-Transfer-Encoding: base64\r\nContent-Type: text/plain\r\n\r\n' + 'Test' + '\r\n--foo_bar_baz--';


    // getIP() {
    //    const calloutURI = 'https://api64.ipify.org?format=json';
    //     fetch(calloutURI, {
    //         method: "GET"
    //     }).then((response) => response.json())
    //         .then(repos => {
    //             console.log(repos)
    //             this.myIp = repos.ip;
    //             console.log(this.myIp);
    //         });
    // }

    getIP() {
       const calloutURI = 'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';
       fetch(calloutURI, {
            method: "POST",
            headers: {'Content-Type': 'multipart/form-data; boundary=foo_bar_baz'},
            mode: "no-cors",
            body: this.body
        }).then((response) => response.json())
            .then(repos => {
                console.log(JSON.stringify(repos));
            });
    }
}