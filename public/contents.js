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
    if(xhr.readyState == 4 && xhr.status == 200){
        a = xhr.response;
        s = "全部で" + a.totalItems + "件あります．<p>";
        s += "<table border=1>";
        s += "<tr><th>タイトル</th><th>著者</th><th>出版社</th><th>ページ数</th><th>発行日</th><th>あらすじ</th></tr>";
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
    }
    document.getElementById("result").innerHTML = s;
}