let bookid = location.pathname.replace(/\/book\//, "");
var xhr = new XMLHttpRequest();
let url = 'https://www.googleapis.com/books/v1/volumes/' + bookid;
xhr.open("GET", url);
xhr.send();
xhr.responseType = 'json';
xhr.onload = ()=> {
    console.log(xhr.response);
    document.getElementById("title").innerHTML = xhr.response.volumeInfo.title;
    document.getElementById("author").innerHTML = xhr.response.volumeInfo.authors;
    document.getElementById("page").innerHTML = xhr.response.volumeInfo.pageCount;
    document.getElementById("publishedDate").innerHTML = xhr.response.volumeInfo.publishedDate;
    document.getElementById("publisher").innerHTML = xhr.response.volumeInfo.publisher;
    document.getElementById("description").innerHTML = xhr.response.volumeInfo.description;
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

let form = document.getElementById("form");
function transmission(){
        
}