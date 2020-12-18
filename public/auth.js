let status = "login";
let errorFlag = false;
let params = [];
function send(obj){
    let request = new XMLHttpRequest();
    if(obj.name == "login"){
        let [name, pass] = (() => {
            let parent = obj.parentNode;
            let cnt = parent.childElementCount;
            temp = ["",""]
            for(let i = 0; i < cnt; i++){
                if(parent.children[i].name == "name")
                    temp[0] = parent.children[i].value;
                if(parent.children[i].name == "pass")
                    temp[1] = parent.children[i].value;
            }
            return temp;
        })();
        params.push({"type" : "login"});
        params.push({
            "name" : name,
            "pass" : pass
        });
        request.open("POST", "http://127.0.0.1:9998/auth");
        request.setRequestHeader("Content-Type", "application/json");
        request.send(JSON.stringify(params));
        request.onload = () => {
            if(request.status == 200){
                console.log("responce");
                location.href = 'http://127.0.0.1:9998/mypage';
            }else{
                let pop = document.getElementById("loginPop");
                if(pop){
                    //popup
                    pop.classList.add('is-show');
                    let background = document.getElementById("popupBack");
                    let closeButton = document.getElementById("loginCloseButton");
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
        };
    }else if(obj.name == "register"){
        let [name, pass] = (() => {
            let parent = obj.parentNode;
            let cnt = parent.childElementCount;
            temp = ["",""]
            for(let i = 0; i < cnt; i++){
                if(parent.children[i].name == "name")
                    temp[0] = parent.children[i].value;
                if(parent.children[i].name == "pass")
                    temp[1] = parent.children[i].value;
            }
            return temp;
        })();
        params.push({"type" : "register"});
        params.push({
            "name" : name,
            "pass" : pass
        });
        request.open("POST", "http://127.0.0.1:9998/auth");
        request.setRequestHeader("Content-Type", "application/json");
        request.send(JSON.stringify(params));
        request.onload = () => {
            if(request.status == 200){
                console.log("responce");
                location.href = 'http://127.0.0.1:9998/success';
            }else{
                let pop = document.getElementById("registerPop");
                if(pop){
                    //popup
                    pop.classList.add('is-show');
                    let background = document.getElementById("popupBack");
                    let closeButton = document.getElementById("registerCloseButton");
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
        };

    }else if(obj.name == "reset"){
        console.log("reset");
        let names = document.getElementsByName("name");
        let passes = document.getElementsByName("pass");
        for (let i = 0; i < names.length;i++){
            names[i].value = "";
        }
        for (let i = 0; i < passes.length;i++){
            passes[i].value = "";
        }
    }
    params = [];
}


function switcher(obj){
    if (obj.id == "registerButton"){
        status = "register";
    }else if (obj.id == "loginButton"){
        status = "login";
    }
    
    dispform(status);
}

function dispform(status){
    let loginElement = document.getElementById("login");
    let registerElement = document.getElementById("register")
    if(loginElement && registerElement){
        console.log(status);
        if (status == "login"){

            //switch
            loginElement.classList.add('is-show');
            registerElement.classList.remove('is-show');
        }else if(status == "register"){
            registerElement.classList.add('is-show');
            loginElement.classList.remove('is-show');
        }
    }
}
