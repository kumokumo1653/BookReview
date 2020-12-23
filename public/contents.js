var xhr = new XMLHttpRequest();
var url = 'https://www.googleapis.com/books/v1/';
function search(){
    t = document.getElementById("key").value;
    xhr.onreadystatechange = checkStatus;
    console.log(url + 'volumes?q=' + t + '&maxResults=20');
    xhr.open('GET', url + 'volumes?q=' + t + '&maxResults=20', true);
    xhr.responseType = 'json';
    xhr.send(null);
}

function checkStatus(){
    s = "";
    if(xhr.readyState == 4){
        if(xhr.status == 200){
            a = xhr.response;
            s = "全部で" + a.totalItems + "件あります．<p>";
            s += "<table class='books' border=1>";
                        
            s += '<tr><th class="title">タイトル</th> <th class="author">著者</th> <th class="publisher">出版社</th> <th class="page">ページ数</th> <th class="publishedDate">発行日</th> <th class="description">あらすじ</th></tr>';
            for (let i = 0; i <a.items.length; i++){
                s += "<tr>";
                s += "<td>" + "<a href='" + "http://127.0.0.1:9998/book/" + a.items[i].id+ "'>"+ a.items[i].volumeInfo.title + "</a></td>";

                if(a.items[i].volumeInfo.authors == undefined)
                    s += "<td>???</td>";
                else{
                    numOfAuthors = a.items[i].volumeInfo.authors.length;
                    s += "<td>";
                    for(j = 0; j < numOfAuthors; j++){
                        s += a.items[i].volumeInfo.authors[j] + " ";
                    } 
                    s += "</td>";
                }
                s += "<td>" + a.items[i].volumeInfo.publisher + "</td>";
                s += "<td>" + a.items[i].volumeInfo.pageCount + "</td>";
                s += "<td>" + a.items[i].volumeInfo.publishedDate + "</td>";
                s += "<td>" + a.items[i].volumeInfo.description + "</td>";
                s += "</tr>";
            }
            s += "</table>";
        }else{
            //error
            console.log(xhr.readyState);
            console.log(xhr.status);
            let limitPop = document.getElementById("limitPop");
            if(limitPop){
                //popup
                limitPop.classList.add('is-show');
            }
            let background = document.getElementById("limitPopupBack");
            let closeButton = document.getElementById("limitButton");
            if(background){
                background.addEventListener('click', () => {
                    limitPop.classList.remove('is-show');
                });
            }
            if(closeButton){
                closeButton.addEventListener('click', () => {
                    limitPop.classList.remove('is-show');
                });
            }
        }
        document.getElementById("result").innerHTML = s;
    }
}


function cancel(){
    document.getElementById("result").innerHTML = "";
}

function popup(){

    let pop = document.getElementById("deletePop");
    if(pop){
        //popup
        pop.classList.add('is-show');
        let background = document.getElementById("deletePopupBack");
        let closeButton = document.getElementById("closeButton");
        if(background){
            background.addEventListener('click', () => {
                pop.classList.remove('is-show');
            });
        }
        if(closeButton){
            closeButton.addEventListener('click', () => {
                pop.classList.remove('is-show');
            });
        }
    }
}
function deleteAccount(){
    console.log("delete");
    let request = new XMLHttpRequest();
    let params = [{"type" : "delete"}];
    request.open("POST", "http://127.0.0.1:9998/delete");
    request.setRequestHeader("Content-Type", "application/json");
    request.send(JSON.stringify(params));
    request.onload = () => {
        if(request.status == 200){
            console.log("responce");
            location.href = 'http://127.0.0.1:9998/success';
        }else{
            console.log("error");
            location.href = 'http://127.0.0.1:9998/fail';
        }
    };
}