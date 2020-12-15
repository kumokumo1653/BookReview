let bookid = location.pathname.replace(/\/book\//, "");
var xhr = new XMLHttpRequest();
let url = 'https://www.googleapis.com/books/v1/volumes/' + bookid;
let param = [];
xhr.open("GET", url);
xhr.send();
xhr.responseType = 'json';
xhr.onload = () => {
    if(xhr.status == 200){
        console.log(xhr.response);
        document.getElementById("title").innerHTML = xhr.response.volumeInfo.title;
        document.getElementById("author").innerHTML = xhr.response.volumeInfo.authors;
        document.getElementById("page").innerHTML = xhr.response.volumeInfo.pageCount;
        document.getElementById("publishedDate").innerHTML = xhr.response.volumeInfo.publishedDate;
        document.getElementById("publisher").innerHTML = xhr.response.volumeInfo.publisher;
        document.getElementById("description").innerHTML = xhr.response.volumeInfo.description;
        param.push({
            "id" : bookid,
            "title" : xhr.response.volumeInfo.title,
            "author" : xhr.response.volumeInfo.authors,
            "page" : xhr.response.volumeInfo.pageCount,
            "publishedDate" : xhr.response.volumeInfo.publishedDate,
            "publisher" : xhr.response.volumeInfo.publisher,
            "description" : xhr.response.volumeInfo.description,
        });
    }
};


let select = 0;
function radioDeselect(obj, num) {
    if(select == num){
        obj.checked = false;
        select = 0;
    }else{
        select = num;
    }
}

function transmission(){
    //let recommend = form.elements['recommend'];
    let form = document.getElementById("input");
    let rating = (() => {
        let rating = form.elements['rating'].value;
        if(rating == "") return 0;
        return parseInt(rating, 10);
    })();

    let comment = form.elements['comment'].value.replace(/[\n|\r|\r\n|　 |\t]/g,'');
    param.push({
        "username" : username,
        "recommend" : form.elements['recommend'].checked,
        "wanna" : form.elements['wanna'].checked,
        "rating" : rating,
        "comment" : comment,
    });
    let request = new XMLHttpRequest();
    request.open("POST", "http://127.0.0.1:9998/review");
    request.setRequestHeader("Content-Type", "application/json");
    request.send(JSON.stringify(param));
    request.onload = function() {
        if(request.status == 200){
            console.log("responce");
        }
    };
    console.log(param);
}
