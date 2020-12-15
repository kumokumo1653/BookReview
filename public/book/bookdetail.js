let bookid = location.pathname.replace(/\/book\//, "");
var xhr = new XMLHttpRequest();
let url = 'https://www.googleapis.com/books/v1/volumes/' + bookid;
let param = [];
let bookinfo = {};
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
        bookinfo = {
            "id" : bookid,
            "title" : xhr.response.volumeInfo.title,
            "author" : xhr.response.volumeInfo.authors,
            "page" : xhr.response.volumeInfo.pageCount,
            "publishedDate" : xhr.response.volumeInfo.publishedDate,
            "publisher" : xhr.response.volumeInfo.publisher,
            "description" : xhr.response.volumeInfo.description,
        };
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

function transmission(obj){
    let form = document.getElementById("input");
    let request = new XMLHttpRequest();
    let rating = (() => {
        let rating = form.elements['rating'].value;
        if(rating == "") return 0;
        return parseInt(rating, 10);
    })();

    let comment = form.elements['comment'].value.replace(/[\n|\r|\r\n|　 |\t]/g,'');
    //追加
    if (obj.innerHTML == "送信"){
        param.push({"type" : "add"});
        param.push(bookinfo);
        param.push({
            "username" : username,
            "recommend" : form.elements['recommend'].checked,
            "wanna" : form.elements['wanna'].checked,
            "rating" : rating,
            "comment" : comment,
        });
        request.open("POST", "http://127.0.0.1:9998/review");
        request.setRequestHeader("Content-Type", "application/json");
        request.send(JSON.stringify(param));
        request.onload = () => {
            if(request.status == 200){
                console.log("responce");
                location.reload();
            }
            param = [];
        };
    }else if (obj.innerHTML == "更新"){
        param.push({"type" : "change"});
        param.push({
            "id" : bookid + username,
            "recommend" : form.elements['recommend'].checked,
            "wanna" : form.elements['wanna'].checked,
            "rating" : rating,
            "comment" : comment,
        });
        request.open("POST", "http://127.0.0.1:9998/review");
        request.setRequestHeader("Content-Type", "application/json");
        request.send(JSON.stringify(param));
        request.onload = () => {
            if(request.status == 200){
                console.log("responce");
                location.reload();
            }
            param = [];
        };
    }else if (obj.innerHTML == "削除"){
        param.push({"type" : "delete"});
        param.push({ "id" : bookid + username });
        request.open("POST", "http://127.0.0.1:9998/review");
        request.setRequestHeader("Content-Type", "application/json");
        request.send(JSON.stringify(param));
        request.onload = () => {
            if(request.status == 200){
                console.log("responce");
                location.reload();
            }
            param = [];
        };
    }
}
