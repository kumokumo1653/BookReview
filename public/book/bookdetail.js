let bookid = location.pathname.replace(/\/book\//, "");
let param = [];
let bookinfo = {};
let select = 0;

function escapeHtml (string) {
  if(typeof string !== 'string') {
    return string;
  }
  return string.replace(/[&"<>]/g, function(match) {
    return {
      '&': '&amp;',
      '"': '&quot;',
      '<': '&lt;',
      '>': '&gt;',
    }[match]
  });
}

window.onload = function () {
if(searchFlag){
    var xhr = new XMLHttpRequest();
    let url = 'https://www.googleapis.com/books/v1/volumes/' + bookid;
    xhr.open("GET", url);
    xhr.send();
    xhr.responseType = 'json';
    xhr.onload = () => {
        if(xhr.status == 200){
            console.log(xhr.response);
            document.getElementById("title").innerHTML = escapeHtml(xhr.response.volumeInfo.title);
            document.getElementById("author").innerHTML = escapeHtml(xhr.response.volumeInfo.authors);
            document.getElementById("page").innerHTML = escapeHtml(xhr.response.volumeInfo.pageCount);
            document.getElementById("publishedDate").innerHTML = escapeHtml(xhr.response.volumeInfo.publishedDate);
            document.getElementById("publisher").innerHTML = escapeHtml(xhr.response.volumeInfo.publisher);
            document.getElementById("description").innerHTML = escapeHtml(xhr.response.volumeInfo.description);
            bookinfo = {
                "id" : bookid,
                "title" : xhr.response.volumeInfo.title,
                "author" : xhr.response.volumeInfo.authors,
                "page" : xhr.response.volumeInfo.pageCount,
                "publishedDate" : xhr.response.volumeInfo.publishedDate,
                "publisher" : xhr.response.volumeInfo.publisher,
                "description" : xhr.response.volumeInfo.description,
            };
        }else{
            console.log("limit");
            let limitPop = document.getElementById("limitPop");
            if(limitPop){
                //popup
                limitPop.classList.add('is-show');
            }
        }
    };
}else{
    console.log("no search");
}

select = (() => {
    let temp = 0;
    let stars = document.getElementsByName("rating");
    for (let i = 0; i < stars.length; i++){
        let star = document.getElementById("label" + String(i + 1));
        if(star){
            if(star.innerText == "★")
                temp = temp < i + 1 ? i + 1 : temp;
        }
    }
    return temp;
})();

};
function radioSelect(obj, num) {
    let stars = document.getElementsByName("rating");
    console.log(select);
    if(select == num){
        obj.checked = false;
        select = 0;
        for(let i = 0; i < stars.length; i++){
            document.getElementById("label" + String(i + 1)).innerText = "☆";
        }
    }else{
        select = num;
        for(let i = 0; i < stars.length; i++){
            if (stars[i].value <= num)
                document.getElementById("label" + String(i + 1)).innerText = "★";
            else
                document.getElementById("label" + String(i + 1)).innerText = "☆";
        }
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

    if (!Object.keys(bookinfo).length){
        bookinfo = {
            "id" : bookid,
            "title" : document.getElementById("title").innerHTML,
            "author" : [document.getElementById("author").innerHTML],
            "page" : parseInt(document.getElementById("page").innerHTML, 10),
            "publishedDate" : document.getElementById("publishedDate").innerHTML,
            "publisher" : document.getElementById("publisher").innerHTML,
            "description" : document.getElementById("description").innerHTML,
        };
    }
    let comment = form.elements['comment'].value;//.replace(/[\n|\r|\r\n|　 |\t]/g,'');
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
            }else{
                writingPop();
            }
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
            }else{
                writingPop();
            }
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
            }else{
                writingPop();
            }
        };
    }
    param = [];
}

function writingPop(){
    console.log("asd");
    let writingPop = document.getElementById("writingPop");
    if(writingPop){
        //popup
        writingPop.classList.add('is-show');
        let background = document.getElementById("popupBack");
        let closeButton = document.getElementById("writingButton");
        if(background){
            background.addEventListener('click', () => {
                writingPop.classList.remove('is-show');
            });
        }
        if(closeButton){
            closeButton.addEventListener('click', () => {
                writingPop.classList.remove('is-show');
            });
        }
    }
}
