let status = "login";
let errorFlag = false;
let params = [];
function send(obj){
    let request = new XMLHttpRequest();
    if(obj.name == "login"){
        params.push({"type" : "login"});
        params.push({
            "name" : document.getElementById("loginName").value,
            "pass" : document.getElementById("loginPass").value
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
                    let background = document.getElementById("popupLoginBack");
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
        params.push({"type" : "register"});
        params.push({
            "name" : document.getElementById("registerName").value,
            "pass" : document.getElementById("registerPass").value
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
                    let background = document.getElementById("popupRegisterBack");
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
